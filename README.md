# Low Level Programmig

## How to check dynamic linking of libso_main by using ldd

I should do like this

```
. .env
ldd libso_main
```

or

```
LD_LIBRARY_PATH=. ldd libso_main
```
