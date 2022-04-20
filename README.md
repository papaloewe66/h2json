## C-header file to json

This script looks up definitions in a c-header file and saves them in a JSON file.
The c-header file requires a defined 'number' with the number of blocks defined. (as starting point)

A RegEx defines the search pattern. The result is stored as "Value" for "Key".

### input File

```txt
#define number 2

#define start0adr   1234
#define end0adr     5678
#define length0     9

#define start1adr   1111
#define end1adr     2222
#define length1     1234
```
### search pattern

```json
{
   "end" : "end([0-9]+)adr",
   "length" : "length([0-9]+)",
   "start" : "start([0-9]+)adr"
}
```

### result

```json
{
   "segment" : [
      {
         "end" : "2222",
         "start" : "1111",
         "length" : "1234"
      },
      {
         "start" : "1234",
         "length" : "9",
         "end" : "5678"
      }
   ]
}
```
### execute

```bash
perl h2json.pl <name>.h (option) <pattern>.json

Result: <name.json>
```
