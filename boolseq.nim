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
    while bb.len < newLen:
        string(bb).add(0.char)

proc `$`*(bb: BoolSeq): string =
    result = ""
    for ch in string(bb):
        result.add(ch.int64.toBin(8))
        result.add(' ')

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

