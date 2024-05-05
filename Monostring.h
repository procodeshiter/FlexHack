#include <mach-o/dyld.h>

#define ASLR_BIAS _dyld_get_image_vmaddr_slide
/*
This struct can hold a native C# array. Credits to caoyin.
Think of it like a wrapper for a C array. For example, if you had Player[] players in a dump,
the resulting monoArray definition would be monoArray<void **> *players;
To get the C array, call getPointer.
To get the length, call getLength.
*/
template <typename T>
struct monoArray
{
    void* klass;
    void* monitor;
    void* bounds;
    int   max_length;
    void* vector [1];
    int getLength()
    {
        return max_length;
    }
    T getPointer()
    {
        return (T)vector;
    }
};

/*
This struct represents a C# string. Credits to caoyin.
It is pretty straight forward. If you have this in a dump,
public class Player {
	public string username; // 0xC8
}
getting that string would look like this: monoString *username = *(monoString **)((uint64_t)player + 0xc8);
C# strings are UTF-16. This means each character is two bytes instead of one.
To get the length of a monoString, call getLength.
To get a NSString from a monoString, call toNSString.
To get a std::string from a monoString, call toCPPString.
To get a C string from a monoString, call toCString.
*/
typedef struct _monoString
{
    void* klass;
    void* monitor;
    int length;    
    char chars[1];   
    int getLength()
    {
      return length;
    }
    char* getChars()
    {
        return chars;
    }
    NSString* toNSString()
    {
      return [[NSString alloc] initWithBytes:(const void *)(chars)
                     length:(NSUInteger)(length * 2)
                     encoding:(NSStringEncoding)NSUTF16LittleEndianStringEncoding];
    }

    char* toCString()
    {
      NSString* v1 = toNSString();
      return (char*)([v1 UTF8String]);  
    }
    std::string toCPPString()
    {
      return std::string(toCString());
    }
}monoString;

/*
This struct represents a List. In the dump, a List is declared as List`1.
Deep down, this simply wraps a C array around a C# list. For example, if you had this in a dump,
public class Player {
	List`1<int> perks; // 0xDC
}
getting that list would look like this: monoList<int *> *perks = *(monoList<int *> **)((uint64_t)player + 0xdc);
You can also get lists that hold objects, but you need to use void ** because we don't have implementation for the Weapon class.
public class Player {
	List`1<Weapon> weapons; // 0xDC
}
getting that list would look like this: monoList<void **> *weapons = *(monoList<void **> **)((uint64_t)player + 0xdc);
If you need a list of strings, use monoString **.
To get the C array, call getItems.
To get the size of a monoList, call getSize.
*/
template <typename T>
struct monoList {
	void *unk0;
	void *unk1;
	monoArray<T> *items;
	int size;
	int version;
	
	T getItems(){
		return items->getPointer();
	}
	
	int getSize(){
		return size;
	}
	
	int getVersion(){
		return version;
	}
};

/*
This struct represents a Dictionary. In the dump, a Dictionary is defined as Dictionary`1.
You could think of this as a Map in Java or C++. Keys correspond with values. This wraps the C arrays for keys and values.
If you had this in a dump,
public class GameManager {
	public Dictionary`1<int, Player> players; // 0xB0
	public Dictionary`1<Weapon, Player> playerWeapons; // 0xB8
	public Dictionary`1<Player, string> playerNames; // 0xBC
}
to get players, it would look like this: monoDictionary<int *, void **> *players = *(monoDictionary<int *, void **> **)((uint64_t)player + 0xb0);
to get playerWeapons, it would look like this: monoDictionary<void **, void **> *playerWeapons = *(monoDictionary<void **, void **> **)((uint64_t)player + 0xb8);
to get playerNames, it would look like this: monoDictionary<void **, monoString **> *playerNames = *(monoDictionary<void **, monoString **> **)((uint64_t)player + 0xbc);
To get the C array of keys, call getKeys.
To get the C array of values, call getValues.
To get the number of keys, call getNumKeys.
To get the number of values, call getNumValues.
*/
template <typename K, typename V>
struct monoDictionary {
	void *unk0;
	void *unk1;
	monoArray<int **> *table;
	monoArray<void **> *linkSlots;
	monoArray<K> *keys;
	monoArray<V> *values;
	int touchedSlots;
	int emptySlot;
	int size;
	
	K getKeys(){
		return keys->getPointer();
	}
	
	V getValues(){
		return values->getPointer();
	}
	
	int getNumKeys(){
		return keys->getLength();
	}
	
	int getNumValues(){
		return values->getLength();
	}
	
	int getSize(){
		return size;
	}
};

/*
Turn a C string into a C# string!
This function is included in Unity's string class. There are two versions of this function in the dump, you want the one the comes FIRST.
The method signature is:
private string CreateString(PTR value);
Again, you want the FIRST one, not the second.
*/
/*
Create a native C# array with a starting length.
This one is kind of tricky to complete. I'm currently looking for an easier way to implement this.
The offsets you need are both found at String::Split(char separator[], int count). Go to that function in IDA and scroll down until you find something like this:
	TBNZ            W20, #0x1F, loc_101153944
	CMP             W20, #1
	B.EQ            loc_1011538B0
	CBNZ            W20, loc_101153924
	ADRP            X8, #qword_1026E0F20@PAGE
	NOP
	LDR             X19, [X8,#qword_1026E0F20@PAGEOFF]
	MOV             X0, X19
	BL              sub_101DD8AF8
	MOV             X0, X19
	MOV             W1, #0
	LDP             X29, X30, [SP,#0x30+var_10]
	LDP             X20, X19, [SP,#0x30+var_20]
	LDP             X22, X21, [SP+0x30+var_30],#0x30
	B               sub_101DD74E8
I filled in the locations here:
	TBNZ            W20, #0x1F, loc_101153944
	CMP             W20, #1
	B.EQ            loc_1011538B0
	CBNZ            W20, loc_101153924
	ADRP            X8, #qword_1026E0F20@PAGE
	NOP
	LDR             X19, [X8,#qword_1026E0F20@PAGEOFF] <-------- Whatever 1026E0F20 is in your game is your second location
	MOV             X0, X19
	BL              sub_101DD8AF8
	MOV             X0, X19
	MOV             W1, #0
	LDP             X29, X30, [SP,#0x30+var_10]
	LDP             X20, X19, [SP,#0x30+var_20]
	LDP             X22, X21, [SP+0x30+var_30],#0x30
	B               sub_101DD74E8						<-------- Whatever 101DD74E8 is in your game is your first location
	
For example, if you wanted an array of 10 ints, you would do this: monoArray<int *> *integers = CreateNativeCSharpArray<int *>(10);
You can use any type with this!*/