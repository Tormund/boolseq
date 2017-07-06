import strutils

type BoolSeq* = distinct string

proc newBoolSeq*(buff: string = ""): BoolSeq=
    result = buff.BoolSeq

proc stateAtPos(chunk: int, p: int): bool=
    result = ((chunk shr p) and 1).bool

proc toggleStateAtPos(chunk: var int, p: int)=
    chunk = chunk xor (1 shl p)

proc len*(bb: BoolSeq): int=
    result = string(bb).len * 8

template size(bb: BoolSeq): int = string(bb).len

proc `[]`*(bb: BoolSeq, key: int): bool=
    assert((key div 8) < bb.size, "index out of bounds")
    result = string(bb)[key div 8].int.stateAtPos(key mod 8)

proc `[]=`*(bb: var BoolSeq, key: int, val: bool)=
    assert((key div 8) < bb.size, "index out of bounds")
    var chunk = string(bb)[key div 8].int
    if chunk.stateAtPos(key mod 8) != val:
        chunk.toggleStateAtPos(key mod 8)
        string(bb)[key div 8] = chunk.char

proc setLen*(bb: var BoolSeq, newLen: int)=
    let tlen = newLen div 8 + (if newLen mod 8 > 0: 1 else: 0)
    let oldLen = bb.len
    string(bb).setLen(tlen)
    for i in oldLen ..< bb.len:
        bb[i] = false

proc `==`*(b1, b2: BoolSeq): bool =
    if b1.string.len != b2.string.len: return false
    for i in 0 ..< b1.string.len:
        if b1.string[i] != b2.string[i]: return false
    # TODO: Warning! This checks last bits that may be not part of the seq
    return true

proc `$`*(bb: BoolSeq): string =
    result = ""
    for ch in string(bb):
        result.add(ch.int64.toBin(8))
        result.add(' ')

template toString*(bb: BoolSeq): string {.deprecated.}=
    bb.string

proc toIntSeq*(bb: BoolSeq): seq[int]=
    result = @[]
    for ch in string(bb):
        result.add(ch.int)

template isNil*(b: BoolSeq): bool = b.string.isNil

when isMainModule:

    let questsStats:string = $[0b0000_0001.char, 0b0000_0000.char]
    let startbb = newBoolSeq(questsStats)
    var outbb = newBoolSeq()
    outbb.setLen(16)

    outbb[0] = true
    outbb[3] = true
    outbb[4] = true
    outbb[6] = true
    outbb[8] = true
    outbb[9] = true
    outbb[13] = true
    outbb[14] = true
    outbb[15] = true

    assert(outbb[0])
    assert(not outbb[1])
    assert(startbb[0])

    outbb.setLen(10)
    assert(outbb[9])
    assert(outbb.len == 16)
    outbb.setLen(4)
    assert(outbb.len == 8)

    assert(not outbb[6])
