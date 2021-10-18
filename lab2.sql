-- 3. Napisz polecenie select, za pomocą którego uzyskasz numer książki (nr tyułu) i
-- autora z tablicy title dla wszystkich książek, których autorem jest Charles
-- Dickens lub Jane Austen

USE library
SELECT title_no, author
FROM title
WHERE author IN ('Charles Dickens', 'Jane Austen')

-- 1. Napisz polecenie, które:
-- – wybiera numer członka biblioteki (member_no), isbn książki (isbn) i watrość
-- naliczonej kary (fine_assessed) z tablicy loanhist dla wszystkich wypożyczeń
-- dla których naliczono karę (wartość nie NULL w kolumnie fine_assessed)
-- – stwórz kolumnę wyliczeniową zawierającą podwojoną wartość kolumny
-- fine_assessed
-- – stwórz alias ‘double fine’ dla tej kolumny

USE library
SELECT member_no,isbn,fine_assessed, fine_assessed * 2 AS [double fine]
FROM loanhist
WHERE fine_assessed IS NOT NULL

-- 1. Napisz polecenie, które
-- – generuje pojedynczą kolumnę, która zawiera kolumny: firstname (imię
-- członka biblioteki), middleinitial (inicjał drugiego imienia) i lastname
-- (nazwisko) z tablicy member dla wszystkich członków biblioteki, którzy
-- nazywają się Anderson
-- – nazwij tak powstałą kolumnę email_name (użyj aliasu email_name dla
-- kolumny)
-- – zmodyfikuj polecenie, tak by zwróciło „listę proponowanych loginów e-mail”
-- utworzonych przez połączenie imienia członka biblioteki, z inicjałem
-- drugiego imienia i pierwszymi dwoma literami nazwiska (wszystko małymi
-- małymi literami).
-- – Wykorzystaj funkcję SUBSTRING do uzyskania części kolumny
-- znakowej oraz LOWER do zwrócenia wyniku małymi literami.
-- Wykorzystaj operator (+) do połączenia stringów.

-- 1. Napisz polecenie, które wybiera title i title_no z tablicy title.
-- Wynikiem powinna być pojedyncza kolumna o formacie jak w przykładzie
-- poniżej:
-- The title is: Poems, title number 7
-- Czyli zapytanie powinno zwracać pojedynczą kolumnę w oparciu o
-- wyrażenie, które łączy 4 elementy:
-- stała znakowa ‘The title is:’
-- wartość kolumny title
-- stała znakowa ‘title number’
-- wartość kolumny title_no
