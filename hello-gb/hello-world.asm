INCLUDE "hardware.inc"

SECTION "Header", ROM0[$100]

	jp EntryPoint

	ds $150 - @, 0 ; Make room for the header

EntryPoint:
	; Shut down audio circuitry
	ld a, 0
	ld [rNR52], a

	; Do not turn the LCD off outside of VBlank
WaitVBlank:
	ld a, [rLY]
	cp 144
	jp c, WaitVBlank

	; Turn the LCD off
	ld a, 0
	ld [rLCDC], a

	; Copy the tile data
	ld de, Tiles
	ld hl, $8000
	ld bc, TilesEnd - Tiles
CopyTiles:
	ld a, [de]
	ld [hli], a
	inc de
	dec bc
	ld a, b
	or a, c
	jp nz, CopyTiles

	; Copy the tilemap
	ld de, Tilemap
	ld hl, $9800
	ld bc, TilemapEnd - Tilemap
CopyTilemap:
	ld a, [de]
	ld [hli], a
	inc de
	dec bc
	ld a, b
	or a, c
	jp nz, CopyTilemap

	; Turn the LCD on
	ld a, LCDCF_ON | LCDCF_BGON
	ld [rLCDC], a

	; During the first (blank) frame, initialize display registers
	ld a, %11100100
	ld [rBGP], a

Done:
	jp Done


SECTION "Tile data", ROM0

Tiles:
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00 ; 0, Space
	db $00, $00, $7f, $7f, $0c, $0c, $0c, $0c, $0c, $0c, $0c, $0c, $0c, $0c, $0c, $0c ; 1, T
	db $00, $00, $43, $43, $43, $43, $43, $43, $7f, $7f, $43, $43, $43, $43, $43, $43 ; 2, H
	db $00, $00, $1c, $1c, $26, $26, $43, $43, $43, $43, $7f, $7f, $43, $43, $43, $43 ; 3, A
	db $00, $00, $43, $43, $63, $63, $73, $73, $5b, $5b, $4f, $4f, $47, $47, $43, $43 ; 4, N
	db $00, $00, $46, $46, $4c, $4c, $78, $78, $78, $78, $4c, $4c, $46, $46, $43, $43 ; 5, K
	db $00, $00, $42, $42, $42, $42, $42, $42, $66, $66, $3c, $3c, $18, $18, $18, $18 ; 6, Y
	db $00, $00, $18, $18, $3c, $3c, $66, $66, $66, $66, $66, $66, $3c, $3c, $18, $18 ; 7, O
	db $00, $00, $43, $43, $43, $43, $43, $43, $43, $43, $43, $43, $67, $67, $3e, $3e ; 8, U

	db $00, $00, $7c, $7c, $66, $66, $7c, $7c, $66, $66, $66, $66, $66, $66, $7c, $7c ; 9, B
	db $00, $00, $7c, $7c, $66, $66, $7c, $7c, $68, $68, $6c, $6c, $66, $66, $62, $62 ; A, R
	db $00, $00, $43, $43, $67, $67, $7f, $7f, $5b, $5b, $43, $43, $43, $43, $43, $43 ; B, M
	db $00, $00, $3f, $3f, $0c, $0c, $0c, $0c, $0c, $0c, $6c, $6c, $6c, $6c, $38, $38 ; C, J
	db $00, $00, $3c, $3c, $62, $62, $60, $60, $3e, $3e, $07, $07, $46, $46, $3c, $3c ; D, S

	; QR code tiles

	db $00, $00, $00, $00, $3F, $3F, $3F, $3F, $30, $30, $30, $30, $33, $33, $33, $33  ;  0xe
	db $00, $00, $00, $00, $FF, $FF, $FF, $FF, $03, $03, $03, $03, $F3, $F3, $F3, $F3  ;  0xf
	db $00, $00, $00, $00, $03, $03, $03, $03, $33, $33, $33, $33, $00, $00, $00, $00  ;  0x10
	db $00, $00, $00, $00, $3C, $3C, $3C, $3C, $03, $03, $03, $03, $33, $33, $33, $33  ;  0x11
	db $00, $00, $00, $00, $03, $03, $03, $03, $F0, $F0, $F0, $F0, $C3, $C3, $C3, $C3  ;  0x12
	db $00, $00, $00, $00, $F3, $F3, $F3, $F3, $33, $33, $33, $33, $03, $03, $03, $03  ;  0x13
	db $00, $00, $00, $00, $FF, $FF, $FF, $FF, $00, $00, $00, $00, $3F, $3F, $3F, $3F  ;  0x14
	db $00, $00, $00, $00, $F0, $F0, $F0, $F0, $30, $30, $30, $30, $30, $30, $30, $30  ;  0x15
	db $33, $33, $33, $33, $33, $33, $33, $33, $30, $30, $30, $30, $3F, $3F, $3F, $3F  ;  0x16
	db $F3, $F3, $F3, $F3, $F3, $F3, $F3, $F3, $03, $03, $03, $03, $FF, $FF, $FF, $FF  ;  0x17
	db $3F, $3F, $3F, $3F, $0C, $0C, $0C, $0C, $3C, $3C, $3C, $3C, $33, $33, $33, $33  ;  0x18
	db $3F, $3F, $3F, $3F, $03, $03, $03, $03, $F3, $F3, $F3, $F3, $33, $33, $33, $33  ;  0x19
	db $3C, $3C, $3C, $3C, $30, $30, $30, $30, $F0, $F0, $F0, $F0, $33, $33, $33, $33  ;  0x1a
	db $F3, $F3, $F3, $F3, $F3, $F3, $F3, $F3, $33, $33, $33, $33, $33, $33, $33, $33  ;  0x1b
	db $3F, $3F, $3F, $3F, $3F, $3F, $3F, $3F, $00, $00, $00, $00, $FF, $FF, $FF, $FF  ;  0x1c
	db $30, $30, $30, $30, $30, $30, $30, $30, $30, $30, $30, $30, $F0, $F0, $F0, $F0  ;  0x1d
	db $00, $00, $00, $00, $3F, $3F, $3F, $3F, $3F, $3F, $3F, $3F, $3F, $3F, $3F, $3F  ;  0x1e
	db $00, $00, $00, $00, $F3, $F3, $F3, $F3, $3C, $3C, $3C, $3C, $03, $03, $03, $03  ;  0x1f
	db $0F, $0F, $0F, $0F, $FC, $FC, $FC, $FC, $C3, $C3, $C3, $C3, $33, $33, $33, $33  ;  0x20
	db $C0, $C0, $C0, $C0, $CF, $CF, $CF, $CF, $30, $30, $30, $30, $00, $00, $00, $00  ;  0x21
	db $30, $30, $30, $30, $0C, $0C, $0C, $0C, $3F, $3F, $3F, $3F, $CC, $CC, $CC, $CC  ;  0x22
	db $30, $30, $30, $30, $3C, $3C, $3C, $3C, $F3, $F3, $F3, $F3, $30, $30, $30, $30  ;  0x23
	db $00, $00, $00, $00, $CC, $CC, $CC, $CC, $F0, $F0, $F0, $F0, $30, $30, $30, $30  ;  0x24
	db $00, $00, $00, $00, $C0, $C0, $C0, $C0, $30, $30, $30, $30, $00, $00, $00, $00  ;  0x25
	db $3C, $3C, $3C, $3C, $30, $30, $30, $30, $03, $03, $03, $03, $00, $00, $00, $00  ;  0x26
	db $FC, $FC, $FC, $FC, $33, $33, $33, $33, $00, $00, $00, $00, $FF, $FF, $FF, $FF  ;  0x27
	db $30, $30, $30, $30, $CF, $CF, $CF, $CF, $CC, $CC, $CC, $CC, $00, $00, $00, $00  ;  0x28
	db $33, $33, $33, $33, $3F, $3F, $3F, $3F, $0C, $0C, $0C, $0C, $F3, $F3, $F3, $F3  ;  0x29
	db $03, $03, $03, $03, $CC, $CC, $CC, $CC, $30, $30, $30, $30, $F0, $F0, $F0, $F0  ;  0x2a
	db $F0, $F0, $F0, $F0, $00, $00, $00, $00, $FF, $FF, $FF, $FF, $3C, $3C, $3C, $3C  ;  0x2b
	db $0C, $0C, $0C, $0C, $0F, $0F, $0F, $0F, $F0, $F0, $F0, $F0, $3F, $3F, $3F, $3F  ;  0x2c
	db $C0, $C0, $C0, $C0, $00, $00, $00, $00, $30, $30, $30, $30, $00, $00, $00, $00  ;  0x2d
	db $03, $03, $03, $03, $0C, $0C, $0C, $0C, $33, $33, $33, $33, $33, $33, $33, $33  ;  0x2e
	db $CC, $CC, $CC, $CC, $3F, $3F, $3F, $3F, $F0, $F0, $F0, $F0, $F3, $F3, $F3, $F3  ;  0x2f
	db $F0, $F0, $F0, $F0, $30, $30, $30, $30, $33, $33, $33, $33, $30, $30, $30, $30  ;  0x30
	db $C0, $C0, $C0, $C0, $FF, $FF, $FF, $FF, $3C, $3C, $3C, $3C, $0C, $0C, $0C, $0C  ;  0x31
	db $F3, $F3, $F3, $F3, $CC, $CC, $CC, $CC, $3F, $3F, $3F, $3F, $FC, $FC, $FC, $FC  ;  0x32
	db $FF, $FF, $FF, $FF, $CC, $CC, $CC, $CC, $CF, $CF, $CF, $CF, $33, $33, $33, $33  ;  0x33
	db $F0, $F0, $F0, $F0, $CF, $CF, $CF, $CF, $F3, $F3, $F3, $F3, $F3, $F3, $F3, $F3  ;  0x34
	db $C0, $C0, $C0, $C0, $00, $00, $00, $00, $30, $30, $30, $30, $00, $00, $00, $00  ;  0x35
	db $30, $30, $30, $30, $30, $30, $30, $30, $00, $00, $00, $00, $3F, $3F, $3F, $3F  ;  0x36
	db $30, $30, $30, $30, $33, $33, $33, $33, $00, $00, $00, $00, $FF, $FF, $FF, $FF  ;  0x37
	db $F3, $F3, $F3, $F3, $CC, $CC, $CC, $CC, $30, $30, $30, $30, $3C, $3C, $3C, $3C  ;  0x38
	db $F3, $F3, $F3, $F3, $0C, $0C, $0C, $0C, $FC, $FC, $FC, $FC, $33, $33, $33, $33  ;  0x39
	db $F0, $F0, $F0, $F0, $0C, $0C, $0C, $0C, $3F, $3F, $3F, $3F, $FC, $FC, $FC, $FC  ;  0x3a
	db $3F, $3F, $3F, $3F, $FF, $FF, $FF, $FF, $30, $30, $30, $30, $F3, $F3, $F3, $F3  ;  0x3b
	db $00, $00, $00, $00, $F3, $F3, $F3, $F3, $3F, $3F, $3F, $3F, $3F, $3F, $3F, $3F  ;  0x3c
	db $C0, $C0, $C0, $C0, $F0, $F0, $F0, $F0, $F0, $F0, $F0, $F0, $00, $00, $00, $00  ;  0x3d
	db $30, $30, $30, $30, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33  ;  0x3e
	db $03, $03, $03, $03, $F3, $F3, $F3, $F3, $F3, $F3, $F3, $F3, $F3, $F3, $F3, $F3  ;  0x3f
	db $00, $00, $00, $00, $30, $30, $30, $30, $3F, $3F, $3F, $3F, $30, $30, $30, $30  ;  0x40
	db $F3, $F3, $F3, $F3, $0C, $0C, $0C, $0C, $F3, $F3, $F3, $F3, $3C, $3C, $3C, $3C  ;  0x41
	db $C3, $C3, $C3, $C3, $CF, $CF, $CF, $CF, $3F, $3F, $3F, $3F, $FC, $FC, $FC, $FC  ;  0x42
	db $F0, $F0, $F0, $F0, $3F, $3F, $3F, $3F, $F0, $F0, $F0, $F0, $FF, $FF, $FF, $FF  ;  0x43
	db $30, $30, $30, $30, $F3, $F3, $F3, $F3, $0F, $0F, $0F, $0F, $FF, $FF, $FF, $FF  ;  0x44
	db $F0, $F0, $F0, $F0, $30, $30, $30, $30, $F0, $F0, $F0, $F0, $C0, $C0, $C0, $C0  ;  0x45
	db $30, $30, $30, $30, $3F, $3F, $3F, $3F, $00, $00, $00, $00, $00, $00, $00, $00  ;  0x46
	db $03, $03, $03, $03, $FF, $FF, $FF, $FF, $00, $00, $00, $00, $00, $00, $00, $00  ;  0x47
	db $3F, $3F, $3F, $3F, $3F, $3F, $3F, $3F, $00, $00, $00, $00, $00, $00, $00, $00  ;  0x48
	db $30, $30, $30, $30, $0C, $0C, $0C, $0C, $00, $00, $00, $00, $00, $00, $00, $00  ;  0x49
	db $30, $30, $30, $30, $CC, $CC, $CC, $CC, $00, $00, $00, $00, $00, $00, $00, $00  ;  0x4a
	db $3C, $3C, $3C, $3C, $C3, $C3, $C3, $C3, $00, $00, $00, $00, $00, $00, $00, $00  ;  0x4b
	db $CC, $CC, $CC, $CC, $F3, $F3, $F3, $F3, $00, $00, $00, $00, $00, $00, $00, $00  ;  0x4c
	db $C0, $C0, $C0, $C0, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00  ;  0x4d
TilesEnd:

SECTION "Tilemap", ROM0

Tilemap:
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,  0,0,0,0,0,0,0,0,0,0,0,0
	db $00, $01, $02, $03, $04, $05, $00, $06, $07, $08, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,  0,0,0,0,0,0,0,0,0,0,0,0
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,  0,0,0,0,0,0,0,0,0,0,0,0
	db $00, $09, $0a, $08, $0b, $0c, $0d, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,  0,0,0,0,0,0,0,0,0,0,0,0
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,  0,0,0,0,0,0,0,0,0,0,0,0
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,  0,0,0,0,0,0,0,0,0,0,0,0
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,  0,0,0,0,0,0,0,0,0,0,0,0
	db $00, $00, $00, $00, $00, $00, $0e, $0f, $10, $11, $12, $13, $14, $15, $00, $00, $00, $00, $00, $00,  0,0,0,0,0,0,0,0,0,0,0,0
	db $00, $00, $00, $00, $00, $00, $16, $17, $18, $19, $1a, $1b, $1c, $1d, $00, $00, $00, $00, $00, $00,  0,0,0,0,0,0,0,0,0,0,0,0
	db $00, $00, $00, $00, $00, $00, $1e, $1f, $20, $21, $22, $23, $24, $25, $00, $00, $00, $00, $00, $00,  0,0,0,0,0,0,0,0,0,0,0,0
	db $00, $00, $00, $00, $00, $00, $26, $27, $28, $29, $2a, $2b, $2c, $2d, $00, $00, $00, $00, $00, $00,  0,0,0,0,0,0,0,0,0,0,0,0
	db $00, $00, $00, $00, $00, $00, $2e, $2f, $30, $31, $32, $33, $34, $35, $00, $00, $00, $00, $00, $00,  0,0,0,0,0,0,0,0,0,0,0,0
	db $00, $00, $00, $00, $00, $00, $36, $37, $38, $39, $3a, $3b, $3c, $3d, $00, $00, $00, $00, $00, $00,  0,0,0,0,0,0,0,0,0,0,0,0
	db $00, $00, $00, $00, $00, $00, $3e, $3f, $40, $41, $42, $43, $44, $45, $00, $00, $00, $00, $00, $00,  0,0,0,0,0,0,0,0,0,0,0,0
	db $00, $00, $00, $00, $00, $00, $46, $47, $48, $49, $4a, $4b, $4c, $4d, $00, $00, $00, $00, $00, $00,  0,0,0,0,0,0,0,0,0,0,0,0
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,  0,0,0,0,0,0,0,0,0,0,0,0
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,  0,0,0,0,0,0,0,0,0,0,0,0
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,  0,0,0,0,0,0,0,0,0,0,0,0
TilemapEnd:
