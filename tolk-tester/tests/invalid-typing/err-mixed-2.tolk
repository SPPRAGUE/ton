// @compilation_should_fail

struct Point {
    x: int8
    y: int8
}

fun alwaysThrow(): never {
    throw 1;
}

// @stderr can not assign `never` to `[...]`
fun cantAssignNeverToShape() {
    var [x] = alwaysThrow();
}

fun map<K, V>.my() {}
type MyBUilder = builder

// @stderr can not assign `string` to `int7`
fun asmFParamMismatch(x: int7 = "not an int"): int
    asm "INC";

// @stderr type `MyBUilder` can not be used as a value
fun invalidMapValueCustomCall() {
    map<int32, MyBUilder>.my();
}

type BadCoins = coins
type BadMap = map<BadCoins, int32>;

// @stderr type `BadCoins` can not be used as a key
fun aliasToInvalidMap() {
    var m: BadMap = [];
}

struct Set<T> {
    private m: map<T, ()>
}

// @stderr type `varuint32` can not be used as a key
fun invalidMapAfterGeneric(cc: Set<varuint32>) {
}

// @stderr can not apply operator `<<` to `never` and `never`
fun cantApplyMathToNever() {
    var p = lazy Point.fromSlice(createEmptySlice());
    match (p) {
        Point => {}
        else => { p << p }
    }
}

// @stderr invalid `map`: type `varint16` can not be used as a key
fun refToFunInvalidMap(): int {
    val f = createEmptyMap<varint16, int8>;
    var m = f();
}
