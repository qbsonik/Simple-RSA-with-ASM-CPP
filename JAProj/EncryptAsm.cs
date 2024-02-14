using System;
using System.Diagnostics;
using System.Runtime.InteropServices;
using System.Text;
using System.Windows.Forms;




namespace JAProj
{
    internal class EncryptAsm
    {
        // Importuj funkcję z biblioteki DLL
        [DllImport(@"C:\Users\kuban\OneDrive\Pulpit\RSA-With-ASM-CPP-DLL-master\x64\Debug\DLL_ASM.dll")]
        private static extern void RSAEncryptAsm(byte[] input, int inputLength, byte[] output, ref int outputLength);

        public void Encrypt(TextBox textToChange, TextBox textAfterChange, Label measuredTime, TrackBar threads)
        {
            try
            {
                // Rozpocznij mierzenie czasu wykonania
                Stopwatch stopwatch = new Stopwatch();
                stopwatch.Start();

                // Pobierz dane do zaszyfrowania z TextBoxa
                string plaintext = textToChange.Text;
                byte[] inputBytes = Encoding.ASCII.GetBytes(plaintext);

                // Bufor na zaszyfrowane dane
                byte[] encryptedBytes = new byte[inputBytes.Length * 2]; // Zakładam, że zaszyfrowane dane nie będą większe niż oryginalne

                // Wywołaj funkcję z biblioteki DLL
                int encryptedLength = encryptedBytes.Length;
                RSAEncryptAsm(inputBytes, inputBytes.Length, encryptedBytes, ref encryptedLength);

                // Przetwórz zaszyfrowane dane (np. wyświetl lub zapisz)
                string encryptedText = Convert.ToBase64String(encryptedBytes, 0, encryptedLength);

                // Wprowadź zaszyfrowany tekst do TextBoxa o nazwie textAfterChange
                textAfterChange.Text = encryptedText;

                // Wyświetl zmierzony czas
                stopwatch.Stop();
                measuredTime.Text = stopwatch.Elapsed.TotalMilliseconds.ToString("F4") + " ms";

            }
            catch (Exception ex)
            {
                MessageBox.Show("Błąd podczas szyfrowania: " + ex.ToString());
            }
        }
    }

    internal class DecryptAsm
    {
        // Importuj funkcję z biblioteki DLL
        [DllImport(@"C:\Users\kuban\OneDrive\Pulpit\RSA-With-ASM-CPP-DLL-master\x64\Debug\DLL_ASM.dll")]

        private static extern void RSADecryptAsm(byte[] input, int inputLength, byte[] output, ref int outputLength);

        public void Decrypt(TextBox textToChange, TextBox textAfterChange, Label measuredTime, TrackBar threads)
        {
            try
            {

                // Rozpocznij mierzenie czasu wykonania
                Stopwatch stopwatch = new Stopwatch();
                stopwatch.Start();


                // Pobierz dane do odszyfrowania z TextBoxa
                string encryptedText = textToChange.Text;
                byte[] inputBytes = Convert.FromBase64String(encryptedText); // Konwertuj zaszyfrowany tekst z formatu Base64 na bajty

                // Bufor na odszyfrowane dane
                byte[] decryptedBytes = new byte[inputBytes.Length];

                // Wywołaj funkcję z biblioteki DLL
                int decryptedLength = 0;
                RSADecryptAsm(inputBytes, inputBytes.Length, decryptedBytes, ref decryptedLength);

                // Przetwórz odszyfrowane dane (np. wyświetl lub zapisz)
                string decryptedText = Encoding.ASCII.GetString(decryptedBytes, 0, decryptedLength); // Konwertuj odszyfrowane bajty na tekst !!!!!! BŁĄD !!!!!!!

                // Wprowadź odszyfrowany tekst do TextBoxa o nazwie textAfterChange
                textAfterChange.Text = decryptedText;

                // Wyświetl zmierzony czas
                stopwatch.Stop();
                measuredTime.Text = stopwatch.Elapsed.TotalMilliseconds.ToString("F4") + " ms";
            }
            catch (Exception ex)
            {
                MessageBox.Show("Błąd podczas odszyfrowywania: " + ex.ToString());
            }
        }
    }
}
