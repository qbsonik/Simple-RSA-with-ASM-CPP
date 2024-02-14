
include listing.inc               ; Dolacza zawartosc pliku listing.inc do kodu zrodlowego.

INCLUDELIB LIBCMT                 ; Instruuje linker do dolaczenia biblioteki LIBCMT (C runtime library, multi-threaded version).
INCLUDELIB OLDNAMES               ; Instruuje linker do dolaczenia biblioteki OLDNAMES dla kompatybilnosci z starszymi nazwami funkcji.

.code                              ; Rozpoczyna sekcje kodu programu.
i = 32                             ; Wskazuje przesuniecie dla zmiennej 'i' na stosie.
n = 36                             ; Wskazuje przesuniecie dla zmiennej 'n' na stosie.
d = 40                             ; Wskazuje przesuniecie dla zmiennej 'd' na stosie.
e = 44                             ; Wskazuje przesuniecie dla zmiennej 'e' na stosie.
input = 64                         ; Wskazuje przesuniecie dla wskaznika 'input' na stosie.
inputLength = 72                   ; Wskazuje przesuniecie dla zmiennej 'inputLength' na stosie.
output = 80                        ; Wskazuje przesuniecie dla wskaznika 'output' na stosie.
outputLength = 88                  ; Wskazuje przesuniecie dla zmiennej 'outputLength' na stosie.
; void RSADecryptAsm(byte* input, int inputLength, byte* output, int* outputLength)
RSADecryptAsm PROC                 ; Rozpoczyna definicje procedury RSADecryptAsm.


	mov	QWORD PTR [rsp+32], r9   ; Zapisuje czwarty argument funkcji na stosie.
	mov	QWORD PTR [rsp+24], r8   ; Zapisuje trzeci argument funkcji na stosie.
	mov	DWORD PTR [rsp+16], edx ; Zapisuje drugi argument funkcji na stosie.
	mov	QWORD PTR [rsp+8], rcx  ; Zapisuje pierwszy argument funkcji na stosie.
	sub	rsp, 56                ; Zajmuje dodatkowe 56 bajtow na stosie dla zmiennych lokalnych.

	lea	r8, [rsp+36]           ; Laduje adres zmiennej 'n' na stosie do rejestru r8.
	lea	rdx, [rsp+40]          ; Laduje adres zmiennej 'd' na stosie do rejestru rdx.
	lea	rcx, [rsp+44]          ; Laduje adres zmiennej 'e' na stosie do rejestru rcx.
	call	generateRSAKeys        ; Wywoluje funkcje generateRSAKeys z zaladowanymi adresami.


	mov	DWORD PTR [rsp+32], 0  ; Inicjalizuje zmienna 'i' wartoscia 0.
	jmp	SHORT JumpHere_1       ; Skacze do etykiety JumpHere_1.
JumpHere_2:
	mov	eax, DWORD PTR [rsp+32] ; Laduje wartosc 'i' do rejestru eax.
	inc	eax                     ; Inkrementuje wartosc w rejestrze eax.
	mov	DWORD PTR [rsp+32], eax ; Zapisuje zaktualizowana wartosc 'i' z powrotem na stos.

JumpHere_1:
	mov	eax, DWORD PTR [rsp+72] ; Laduje dlugosc danych wejsciowych do rejestru eax.
	cmp	DWORD PTR [rsp+32], eax ; Porownuje 'i' z dlugoscia danych wejsciowych.
	jge	SHORT JumpHere_3       ; Skacze, jesli 'i' jest wieksze lub rowne dlugosci danych wejsciowych.

	movsxd	rax, DWORD PTR [rsp+32] ; Rozszerza 'i' do rozmiaru qword i laduje do rax.
	mov	rcx, QWORD PTR [rsp+64]  ; Laduje wskaznik 'input' do rcx.
	movzx	eax, BYTE PTR [rcx+rax] ; Laduje bajt z 'input[i]' do eax, zero rozszerzajac.
	mov	r8d, DWORD PTR [rsp+36] ; Laduje 'n' do r8d.
	mov	edx, DWORD PTR [rsp+40] ; Laduje 'd' do edx.
	mov	ecx, eax                ; Przenosi zaladowany bajt do ecx.
	call	powermod                ; Wywoluje funkcje powermod.
	movsxd	rcx, DWORD PTR [rsp+32] ; Rozszerza 'i' do rozmiaru qword i laduje do rcx.
	mov	rdx, QWORD PTR [rsp+80] ; Laduje wskaznik 'output' do rdx.
	mov	BYTE PTR [rdx+rcx], al  ; Zapisuje wynik funkcji powermod do 'output[i]'.

	jmp	SHORT JumpHere_2       ; Powtarza petle dla nastepnego bajtu.
	
JumpHere_3:
	mov	rax, QWORD PTR [rsp+88] ; Laduje wskaznik 'outputLength' do rax.
	mov	ecx, DWORD PTR [rsp+72] ; Laduje dlugosc danych wejsciowych do ecx.
	mov	DWORD PTR [rax], ecx    ; Zapisuje dlugosc danych wejsciowych jako dlugosc danych wyjsciowych.

	add	rsp, 56                ; Zwalnia zarezerwowane miejsce na stosie.
	ret                         ; Zwraca z funkcji.
RSADecryptAsm ENDP               ; Konczy definicje procedury RSADecryptAsm.

i = 32
n = 36
e = 40
d = 44
helper = 48
input = 80
inputLength = 88
output = 96
outputLength = 104
;void RSAEncryptAsm(byte* input, int inputLength, byte* output, int* outputLength)
; Procedura RSAEncryptAsm

RSAEncryptAsm PROC            ; Rozpocz�cie procedury RSAEncryptAsm.

    ; Zapisanie argument�w przekazanych do procedury na stosie.
    mov QWORD PTR [rsp+32], r9  ; Zapisuje czwarty argument funkcji na stosie  
    mov QWORD PTR [rsp+24], r8  ; Zapisuje trzeci argument funkcji na stosie  
    mov DWORD PTR [rsp+16], edx ; Zapisuje d�ugo�� danych wej�ciowych jako drugi argument.
    mov QWORD PTR [rsp+8], rcx  ; Zapisuje wska�nik do danych wej�ciowych jako pierwszy argument.
    sub rsp, 72                 ; Alokacja miejsca na stosie dla zmiennych lokalnych.

    ; Generowanie kluczy RSA.
    lea r8, [rsp+36]            ; Przygotowuje adres zmiennej 'n' dla funkcji generateRSAKeys.
    lea rdx, [rsp+40]           ; Przygotowuje adres zmiennej 'e' dla funkcji generateRSAKeys.
    lea rcx, [rsp+44]           ; Przygotowuje adres zmiennej 'd' dla funkcji generateRSAKeys.
    call generateRSAKeys        ; Wywo�anie funkcji generateRSAKeys.

    ; P�tla szyfruj�ca dane wej�ciowe.
    mov DWORD PTR i[rsp], 0     ; Inicjalizacja licznika p�tli 'i' na 0.
    jmp SHORT JumpHere_5        ; Skok do warunku p�tli.
JumpHere_4:
    mov eax, DWORD PTR i[rsp]   ; Zwi�kszenie licznika p�tli 'i'.
    inc eax
    mov DWORD PTR i[rsp], eax
JumpHere_5:
    mov eax, DWORD PTR inputLength[rsp] ; Pobranie d�ugo�ci danych wej�ciowych.
    cmp DWORD PTR i[rsp], eax   ; Por�wnanie licznika p�tli 'i' z d�ugo�ci� danych wej�ciowych.
    jge SHORT JumpHere_6        ; Je�li 'i' >= d�ugo�� danych wej�ciowych, zako�czenie p�tli.

    ; Szyfrowanie pojedynczego bajtu.
    movsxd rax, DWORD PTR i[rsp] ; Rozszerzenie 'i' do rozmiaru qword.
    mov QWORD PTR helper[rsp], rax ; Zapisanie 'i' do zmiennej pomocniczej.
    movsxd rcx, DWORD PTR i[rsp] ; Rozszerzenie 'i' do rozmiaru qword (ponownie, dla adresu).
    mov rdx, QWORD PTR input[rsp] ; Pobranie wska�nika do danych wej�ciowych.
    movzx ecx, BYTE PTR [rdx+rcx] ; Pobranie i-tego bajtu z danych wej�ciowych.
    mov r8d, DWORD PTR n[rsp]     ; Pobranie 'n' dla funkcji powermod.
    mov edx, DWORD PTR e[rsp]     ; Pobranie 'e' dla funkcji powermod.
    call powermod                 ; Wywo�anie funkcji powermod.

    ; Dodanie zaszyfrowanego bajtu do danych wyj�ciowych.
    mov rcx, QWORD PTR output[rsp] ; Pobranie wska�nika do danych wyj�ciowych.
    mov rdx, QWORD PTR helper[rsp]   ; Pobranie wcze�niej zapisanej warto�ci 'i'.
    movzx ecx, BYTE PTR [rcx+rdx]  ; Pobranie aktualnej warto�ci i-tego bajtu danych wyj�ciowych.

    ; Operacja dodawania wektorowego z u�yciem rejestr�w SIMD.
    movd xmm0, eax                ; Przeniesienie wyniku powermod do xmm0.
    movd xmm1, ecx                ; Przeniesienie bajtu danych wyj�ciowych do xmm1.
    paddd xmm0, xmm1              ; Dodawanie wektorowe: aktualizacja bajtu danych wyj�ciowych.
    movd eax, xmm0                ; Zapisanie zaktualizowanego bajtu z powrotem do eax.

    ; Zapisanie zaktualizowanego bajtu do danych wyj�ciowych.
    movsxd rcx, DWORD PTR i[rsp]  ; Rozszerzenie 'i' do rozmiaru qword.
    mov rdx, QWORD PTR output[rsp] ; Pobranie wska�nika do danych wyj�ciowych.
    mov BYTE PTR [rdx+rcx], al    ; Zapisanie zaszyfrowanego bajtu.

    jmp SHORT JumpHere_4          ; Powr�t do kolejnej iteracji p�tli.
JumpHere_6:

    ; Zapisanie d�ugo�ci danych wyj�ciowych r�wnoznacznej z d�ugo�ci� danych wej�ciowych.
    mov rax, QWORD PTR outputLength[rsp] ; Pobranie wska�nika do zmiennej d�ugo�ci danych wyj�ciowych.
    mov ecx, DWORD PTR inputLength[rsp]  ; Pobranie d�ugo�ci danych wej�ciowych.
    mov DWORD PTR [rax], ecx              ; Zapisanie d�ugo�ci danych wej�ciowych jako d�ugo�ci danych wyj�ciowych.

    add rsp, 72                          ; Zwalnianie zarezerwowanego miejsca na stosie.
    ret                                  ; Zwr�cenie z procedury.
RSAEncryptAsm ENDP                      ; Zako�czenie definicji procedury RSAEncryptAsm.

result = 0
base = 32
exp = 40
modulus = 48
powermod PROC                ; Rozpoczyna procedur� powermod, kt�ra oblicza (base^exp) % modulus.

    ; Przygotowanie stosu i zapisanie argument�w funkcji na stosie.
    mov DWORD PTR [rsp+24], r8d   ; Zapisuje trzeci argument (modulus) na stosie.
    mov DWORD PTR [rsp+16], edx   ; Zapisuje drugi argument (exp) na stosie.
    mov DWORD PTR [rsp+8], ecx    ; Zapisuje pierwszy argument (base) na stosie.
    sub rsp, 24                   ; Alokacja miejsca na stosie dla zmiennych lokalnych.

    ; Inicjalizacja zmiennej lokalnej result warto�ci� 1.
    mov DWORD PTR result[rsp], 1  ; Ustawia pocz�tkow� warto�� 'result' na 1.

    ; Rozpocz�cie p�tli: wykonuje, dop�ki exp > 0.
JumpHere_7:
    cmp DWORD PTR exp[rsp], 0     ; Por�wnuje 'exp' z 0, aby sprawdzi�, czy jest wi�ksze.
    jle SHORT JumpHere_9          ; Skacze, je�li 'exp' jest mniejsze lub r�wne 0 (ko�czy p�tl�).

    ; Sprawdzenie, czy najm�odszy bit 'exp' jest ustawiony (czy 'exp' jest nieparzyste).
    mov eax, DWORD PTR exp[rsp]   ; �aduje 'exp' do eax.
    and eax, 1                    ; Wykonuje operacj� AND na eax, aby sprawdzi�, czy jest nieparzyste.
    test eax, eax                 ; Testuje wynik operacji AND.
    je SHORT JumpHere_8           ; Skacze, je�li 'exp' jest parzyste (najm�odszy bit nie jest ustawiony).

    ; Je�li 'exp' jest nieparzyste, aktualizuje 'result'.
    mov eax, DWORD PTR result[rsp] ; �aduje 'result' do eax.
    imul eax, DWORD PTR base[rsp]  ; Mno�y 'result' przez 'base'.
    cdq                            ; Rozszerza eax na edx:eax przed dzieleniem.
    idiv DWORD PTR modulus[rsp]    ; Dzieli edx:eax przez 'modulus', wynik w eax, reszta w edx.
    mov eax, edx                   ; Przenosi reszt� (nowy 'result') do eax.
    mov DWORD PTR result[rsp], eax ; Zapisuje zaktualizowany 'result'.

    ; Aktualizacja 'base': base = (base * base) % modulus.
JumpHere_8:
    mov eax, DWORD PTR base[rsp]   ; �aduje 'base' do eax.
    imul eax, eax                  ; Mno�y 'base' przez siebie.
    cdq                            ; Rozszerza eax na edx:eax przed dzieleniem.
    idiv DWORD PTR modulus[rsp]    ; Dzieli edx:eax przez 'modulus', wynik w eax, reszta w edx.
    mov eax, edx                   ; Przenosi reszt� (nowy 'base') do eax.
    mov DWORD PTR base[rsp], eax   ; Zapisuje zaktualizowany 'base'.

    ; Aktualizacja 'exp': przesuwa 'exp' w prawo o 1 bit (dzielenie przez 2).
    mov eax, DWORD PTR exp[rsp]    ; �aduje 'exp' do eax.
    sar eax, 1                     ; Przesuwa warto�� 'exp' w prawo o 1 (dzieli przez 2).
    mov DWORD PTR exp[rsp], eax    ; Zapisuje zaktualizowany 'exp'.

    ; Warunkowe zako�czenie p�tli: je�li 'exp' jest ju� 0, zwraca 'result'.
    mov eax, DWORD PTR result[rsp] ; �aduje 'result', aby zwr�ci� jako wynik funkcji.
    jmp SHORT JumpHere_10          ; Skacze do ko�ca funkcji, aby zwr�ci� wynik.

    jmp SHORT JumpHere_7           ; Kontynuuje p�tl�, je�li 'exp' nie osi�gn�o jeszcze 0.
JumpHere_9:
    ; Osi�gni�to, gdy 'exp' jest 0; gotowe do zwr�cenia 'result'.
JumpHere_10:

    add rsp, 24                    ; Zwalnia zarezerwowane miejsce na stosie.
    ret                            ; Zwraca z funkcji.
powermod ENDP                     ; Ko�czy definicj� procedury powermod.

; Inicjalizacja zmiennych pomocniczych dla procedury generateRSAKeys
i = 0
p = 4
q = 8
phi = 12
e = 32
d = 40
n = 48

generateRSAKeys PROC            ; Rozpoczyna procedur� generateRSAKeys.

    ; Przygotowanie stosu pod zmienne lokalne i parametry
    mov QWORD PTR [rsp+24], r8  ; Zapisuje trzeci argument procedury na stosie.
    mov QWORD PTR [rsp+16], rdx ; Zapisuje drugi argument procedury na stosie.
    mov QWORD PTR [rsp+8], rcx  ; Zapisuje pierwszy argument procedury na stosie.
    sub rsp, 24                 ; Alokacja miejsca na stosie dla zmiennych lokalnych.

    ; Inicjalizacja zmiennych 'p' i 'q' z ustalonymi warto�ciami
    mov DWORD PTR p[rsp], 61    ; Inicjalizacja zmiennej 'p' warto�ci� 61.
    mov DWORD PTR q[rsp], 73    ; Inicjalizacja zmiennej 'q' warto�ci� 73.

    ; Ustawienie warto�ci zmiennej 'e'
    mov rax, QWORD PTR e[rsp]   ; �aduje adres zmiennej 'e'.
    mov DWORD PTR [rax], 2137   ; Ustawienie warto�ci 'e' na 2137.

    ; Obliczenie 'n' jako iloczyn 'p' i 'q'
    mov eax, DWORD PTR p[rsp]   ; �aduje warto�� 'p' do rejestru eax.
    imul eax, DWORD PTR q[rsp]  ; Mno�y 'p' przez 'q'.
    mov rcx, QWORD PTR n[rsp]   ; �aduje adres zmiennej 'n'.
    mov DWORD PTR [rcx], eax    ; Zapisuje wynik mno�enia jako 'n'.

    ; Obliczenie warto�ci 'phi' jako (p-1)*(q-1)
        ; Za�aduj warto�� 1 do xmm1 i xmm2, aby przygotowa� do odejmowania.
    mov eax, 1                   ; �aduje warto�� 1 do rejestru eax.
    movd xmm1, eax               ; Przenosi warto�� 1 do xmm1.
    movd xmm2, eax               ; Przenosi warto�� 1 do xmm2  
    vmovd xmm0, DWORD PTR p[rsp]
    vpsubd xmm0, xmm0, xmm1     ; Odejmuje 1 od 'p' (xmm1 zawiera warto�� 1).
    vmovd xmm1, DWORD PTR q[rsp]
    vpsubd xmm1, xmm1, xmm2     ; Odejmuje 1 od 'q' (xmm2 zawiera warto�� 1).
    vpmulld xmm0, xmm0, xmm1    ; Mno�y (p-1) przez (q-1).
    vmovd eax, xmm0             ; Zapisuje wynik mno�enia do eax.
    mov DWORD PTR phi[rsp], eax ; Zapisuje wynik jako 'phi'.

    ; Wyb�r 'd' tak, aby (d * e) % phi = 1
    mov DWORD PTR i[rsp], 2     ; Inicjalizacja zmiennej 'i' warto�ci� 2.
    jmp SHORT JumpHere_12       ; Skok do sprawdzenia warunku p�tli.
JumpHere_11:
    mov eax, DWORD PTR i[rsp]   ; Inkrementacja 'i'.
    inc eax
    mov DWORD PTR i[rsp], eax
JumpHere_12:
    mov eax, DWORD PTR phi[rsp] ; �aduje 'phi' do por�wnania.
    cmp DWORD PTR i[rsp], eax   ; Por�wnuje 'i' z 'phi'.
    jge SHORT JumpHere_14       ; Je�li 'i' >= 'phi', ko�czy p�tl�.

    ; Sprawdzenie, czy (e * i) % phi = 1
    mov rax, QWORD PTR e[rsp]   ; �aduje adres zmiennej 'e'.
    mov eax, DWORD PTR [rax]    ; �aduje warto�� 'e'.
    imul eax, DWORD PTR i[rsp]  ; Mno�y 'e' przez 'i'.
    cdq                         ; Rozszerza eax do edx:eax przed dzieleniem.
    idiv DWORD PTR phi[rsp]     ; Dzieli przez 'phi', reszta w edx.
    mov eax, edx                ; Przenosi reszt� do eax.
    cmp eax, 1                  ; Por�wnuje reszt� z 1.
    jne SHORT JumpHere_13       ; Je�li reszta ? 1, kontynuuje p�tl�.

    ; Zapisanie 'i' jako 'd', gdy warunek jest spe�niony
    mov rax, QWORD PTR d[rsp]   ; �aduje adres zmiennej 'd'.
    mov ecx, DWORD PTR i[rsp]   ; �aduje 'i'.
    mov DWORD PTR [rax], ecx    ; Zapisuje 'i' jako 'd'.

    jmp SHORT JumpHere_14       ; Wyj�cie z p�tli.
JumpHere_13:
    jmp SHORT JumpHere_11       ; Powr�t do inkrementacji 'i'.
JumpHere_14:

    add rsp, 24                 ; Zwalnia zarezerwowane miejsce na stosie.
    ret                         ; Zwraca z funkcji.
generateRSAKeys ENDP           ; Ko�czy definicj� procedury generateRSAKeys.
END