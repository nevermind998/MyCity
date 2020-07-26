using backendPoSlojevima.DAL.Interfaces;
using backendPoSlojevima.Data;
using backendPoSlojevima.Models;
using MailKit.Net.Smtp;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Configuration;
using MimeKit;
//using Microsoft.VisualStudio.Web.CodeGeneration.Contracts.Messaging;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Security.Cryptography;
using System.Text;

namespace backendPoSlojevima.DAL
{
    public class KorisnikDAL : IKorisnikDAL
    {
        private readonly ApplicationDbContext _context;
        private readonly IWebHostEnvironment _IWebHostEnvironment;
        private readonly IConfiguration _configuration;
        private readonly AuthRepository _auth;

        public KorisnikDAL(ApplicationDbContext context, IWebHostEnvironment IWebHostEnvironment, IConfiguration configuration)
        {
            _context = context;
            _IWebHostEnvironment = IWebHostEnvironment;
            _configuration = configuration;
            _auth = new AuthRepository(configuration);

        }
        public List<Korisnik> getAllKorisnik()
        {

            return _context.korisnik.Where(k => k.id > 1).ToList();
        }
        public int deleteKorisnikaByAdmin(Korisnik korisnik, String token)
        {
            if (korisnik.uloga != "superuser" )
            {    
                if (korisnik.urlSlike != null ) this.deleteProfilPicture(korisnik);
                _context.korisnik.Remove(korisnik);
                _context.SaveChanges();
                return 1;
            }
            return 0;
        }

        public void deleteKorisnika(Korisnik korisnik, String token)
        {
            var provera = this.proveraKorisnika(korisnik.id, token);
            if (provera == 0)
            {
                //proveri da nije token admina
                int ind = this.proveriTokenAdmina(token);
                if (ind == 0   ) return;
                if (ind == 1 && korisnik.uloga == "admin"   ) return;
            }
            if (korisnik != null)
            {
                if (korisnik.uloga == "superuser") return;
                this.deleteProfilPicture(korisnik);
                _context.korisnik.Remove(korisnik);
                _context.SaveChanges();
            }

        }

        private void deleteProfilPicture(Korisnik korisnik)
        {
            if (korisnik.urlSlike != null)
            {
                var PathWithFolderName = System.IO.Path.Combine(_IWebHostEnvironment.WebRootPath, korisnik.urlSlike);
                if (File.Exists(PathWithFolderName))
                {
                    File.Delete(PathWithFolderName);
                }

            }
        }
        public Korisnik saveKorisnik(Korisnik korisnik)
        {
            Korisnik check = _context.korisnik.FirstOrDefault(k => k.username == korisnik.username);

            if (check != null) return null; //we have this username
            korisnik.uloga = "korisnik";
            korisnik.poeni = 0;
            korisnik.ocenaAplikacije = -1;
            var id = _context.korisnik.Count();
            if (id == 0)
            {
                korisnik.id = 1;
            }
            else
            {
                korisnik.id = _context.korisnik.Max(o => o.id) + 1;
            }
            
            _context.korisnik.Add(korisnik);
            _context.SaveChanges();
            return korisnik; // ok
        }

        public long proveraKorisnika(Korisnik korisnik)
        {
            Korisnik check = _context.korisnik.FirstOrDefault(k => k.username == korisnik.username);

            if (check != null) return -1; //we have this username
            Korisnik checkMail = _context.korisnik.FirstOrDefault(k => k.email == korisnik.email);
            if (checkMail != null) return -2;
            var id = _context.korisnik.Count();
            return 1;
          /*  if (id == 0)
            {
                korisnik.id = 1;
            }
            else
            {
                korisnik.id = _context.korisnik.Max(o => o.id) + 1;
            }
            return korisnik.id; // ok*/
        }


        private int checkUserName(String username, long id)
        {
            username = username.Trim();
            var check = _context.korisnik.FirstOrDefault(k => k.username == username && k.id != id);

            if (check != null) return 1;
            return 0;
        }

        public int izmeniPodatke(AzuriranjeKorisnika podatak, Korisnik korisnik, String token)
        {
            int provera = this.proveraKorisnika(korisnik.id, token);
            if (provera == 0)
            {
                return 1;
            }
            Korisnik data = podatak.korisnik;
            if (data.username != null)
            {
                int ind = this.checkUserName(data.username, data.id);
                if (ind == 1) return -1; //ne valja username
                korisnik.username = data.username;
            };
            if (data.password != null)
            {
                var ind = _context.korisnik.FirstOrDefault(k => k.id == data.id && data.password == k.password);
                if (ind == null) return -2; //ne valja sifra
                korisnik.password = podatak.newPassword;
            }
            if (data.ime != null)
            {
                korisnik.ime = data.ime;
            }
            if (data.prezime != null)
            {
                korisnik.prezime = data.prezime;
            }


            if (data.email != null)
            {
                korisnik.email = data.email;
            }
            if (data.biografija != null)
            {
                korisnik.biografija = data.biografija;
            }
            //SIFRA TEK TREBA DA SE MENJA*/
            //_context.korisnik.Update(korisnik1);
            _context.SaveChanges();
            return 1; //sve okl

        }

        public void saveProfilImage(PrihvatanjeSlike slika, String token)
        {
            var korisnik = _context.korisnik.FirstOrDefault(k => k.Token == token);
            var id = korisnik.id;
            korisnik.urlSlike = "korisnici//profilImage//image" + id + ".jpg";
            String webRoot = _IWebHostEnvironment.WebRootPath;
            var PathWithFolderName = System.IO.Path.Combine(webRoot, korisnik.urlSlike);
            var stream = System.IO.File.Create(PathWithFolderName);
            slika.slika.CopyTo(stream);
            // _context.korisnik.Update(korisnik);
            _context.SaveChanges();
        }

        public void dodajProfilnuSlikuKorisniku(Korisnik korisnik)
        {
            long id = _context.korisnik.Count();
            if (id == 0)
            {
                id = 1;
            }
            else
            {
                id = _context.korisnik.Max(s => s.id) + 1;
            }
            korisnik.urlSlike = "korisnici//profilImage//image" + id + ".jpg"; //nemoguce da se cuva slika na ovaj nacin, losa dodela imena
            _context.korisnik.Update(korisnik);
            _context.SaveChanges();
        }

        public Korisnik dodajTokenKorisniku(Korisnik korisnik)
        {
            var response = _auth.CreateToken(korisnik);
            korisnik.Token = response;
            _context.korisnik.Update(korisnik);
            _context.SaveChanges();
            return korisnik;
        }

        public Korisnik unistiToken(Korisnik korisnik, String token)
        {
            var provera = this.proveraKorisnika(korisnik.id, token);
            if (provera == 0)
            {
                return null;
            }
            korisnik.Token = null;
            _context.korisnik.Update(korisnik);
            _context.SaveChanges();
            return korisnik;

        }


        public Korisnik LoginCheck(Korisnik k)
        {
            k.username = k.username.Trim();
            var check = _context.korisnik.FirstOrDefault(c => c.username.Equals(k.username) && c.password.Equals(k.password) && (c.uloga != "institucija") );

            if (check == null)
            {
                return null;
            }
            // var check = korisnici.FirstOrDefault(c => c.username.Equals(k.username) && c.password.Equals(k.password) && (c.uloga != "institucija"));
            check = this.dodajTokenKorisniku(check);
            return check;
        }

        public Korisnik getKorisnikaById(long idKorisnika)
        {
            return _context.korisnik.FirstOrDefault(k => k.id == idKorisnika);
        }

        public void zaboravljenaSifra(ZaboravljenaSifra data)
        {
            Korisnik korisnik;
            if (data.username != null)
            {
                korisnik = _context.korisnik.FirstOrDefault(k => k.username == data.username);
            }
         /*   else if (data.email != null)
            {
                korisnik = _context.korisnik.FirstOrDefault(k => k.email == data.email);
            }*/
            else
            {
                return;
            }
           
            if (korisnik == null) return;
            var message = new MimeMessage();
            message.From.Add(new MailboxAddress("Moj grad", "mojgrad2020@gmail.com"));
            message.To.Add(new MailboxAddress("Moj grad", korisnik.email));
            message.Subject = "Moj grad";
            var random = new Random();
            var kod = random.Next(1000);
            kod = kod + random.Next(20, 200);
            kod *= (kod/2);
            kod = kod + random.Next(100, 200);
            message.Body = new TextPart("plain")
            {
                Text = "Poštovani,\nVaša privremena šifra je " + kod + ". Možete se ulogovati na aplikaciju Moj grad, pomoću nove šifre. Šifru možete promeniti u okviru izmene profila, koja se nalazi na Vašem profilu.\nPozdrav,\nAplikacija Moj grad."

            };
            using (var client = new SmtpClient())
            {

                client.Connect("smtp.gmail.com", 587, false);
                client.Authenticate("mojgrad2020@gmail.com", "kragujevac034");
                client.Send(message);
                client.Disconnect(true);
                //client.Dispose();
            }
            korisnik.password = KorisnikDAL.Hash(String.Concat(kod));
            _context.SaveChanges();
        }
        static string Hash(string input)
        {
            using (SHA1Managed sha1 = new SHA1Managed())
            {
                var hash = sha1.ComputeHash(Encoding.UTF8.GetBytes(input));
                var sb = new StringBuilder(hash.Length * 2);

                foreach (byte b in hash)
                {
                    // can be "x2" if you want lowercase
                    sb.Append(b.ToString("x2"));
                }

                return sb.ToString();
            }
        }
        public Korisnik postaviAdmina(Korisnik admin)
        {
            if (admin != null)
            {
                var message = new MimeMessage();
                message.From.Add(new MailboxAddress("Moj grad", "mojgrad2020@gmail.com"));
                message.To.Add(new MailboxAddress("Moj grad", admin.email));
                message.Subject = "Moj grad";
                message.Body = new TextPart("plain")
                {
                    Text = "Poštovani,\nČestitamo, postali ste administrator aplikacije Moj grad. Potrebno je da savesno i odgovorno koristite Vašu privilegiju. Link do administratorske stranice je http://147.91.204.116:2071/index.html#/. \n Puno pozdrava,\nAplikacija Moj grad."
                };
                using (var client = new SmtpClient())
                {

                    client.Connect("smtp.gmail.com", 587, false);
                    client.Authenticate("mojgrad2020@gmail.com", "kragujevac034");
                    client.Send(message);
                    client.Disconnect(true);
                    //client.Dispose();
                }

                admin.uloga = "admin";
                _context.korisnik.Update(admin);
                _context.SaveChanges();
                return admin;

            }
            return null;
        }

        public int proveraIdKorisnika(long idKorisnika)
        {
            var check = _context.korisnik.FirstOrDefault(k => k.id == idKorisnika);
            if (check != null)
            {
                return 1;
            }
            return 0;
        }

        private int proveraKorisnika(long idKorisnika, String token)
        {

            var check = _context.korisnik.FirstOrDefault(k => k.Token == token);
            if (check == null)
            {
                return 0;
            }
            if (check.id == idKorisnika)
            {
                return 1;
            }
            else
            {
                return 0;
            }
        }


        private int proveriTokenAdmina(String token)
        {
            var check = _context.korisnik.FirstOrDefault(k => k.Token == token && (k.uloga == "admin" || k.uloga == "superuser"));
            if (check == null)
            {
                return 0;
            }
            else
            {
                return 1;
            }
        }

        public void oduzmiPoeneKorisniku(PrihvatanjePoena poeni)
        {
            var korisnik = _context.korisnik.FirstOrDefault(k => k.id == poeni.idKorisnika);
            korisnik.poeni = korisnik.poeni - poeni.poeni;
            if (korisnik.poeni == 0) korisnik.poeni = 0;


            _context.SaveChanges();
        }

        public void dodajPoeneKorisniku(PrihvatanjePoena poeni)
        {
            var korisnik = _context.korisnik.FirstOrDefault(k => k.id == poeni.idKorisnika);
            korisnik.poeni = korisnik.poeni + poeni.poeni;
            _context.SaveChanges();
        }

        public List<Korisnik> getKorisnikByFilter(string data)
        {
            if (data == "") return _context.korisnik.Where(k => k.uloga != "superuser").ToList();
            List<Korisnik> korisnikByFilter = _context.korisnik.Where(k => k.uloga != "institucija" && k.uloga != "superuser" && (k.username.ToLower().Contains(data.ToLower()) || k.ime.ToLower().Contains(data.ToLower()) || k.prezime.ToLower().Contains(data.ToLower()))).ToList();
            List<Korisnik> institucijaByFilter = _context.korisnik.Where(k => k.uloga == "institucija" && k.uloga != "superuser" && (k.username.ToLower().Contains(data.ToLower()) || k.ime.ToLower().Contains(data.ToLower()))).ToList();
            List<Korisnik> lista = new List<Korisnik>();
            if (korisnikByFilter.Count() > 0)
            {
                lista.AddRange(korisnikByFilter);
            }
            if (institucijaByFilter.Count() > 0)
            {
                lista.AddRange(institucijaByFilter);
            }
            return lista;
        }


        public List<Boje> getBoje()
        {
            return _context.gejmifikacija.ToList();
        }
        public Boje getBojeById(long idBoje)
        {
            return _context.gejmifikacija.FirstOrDefault(b => b.id == idBoje);
        }


        public int proveraKoda(PrihvatanjeKoda data)
        {
            /*  var korisnik = _context.korisnik.FirstOrDefault(k => k.id == data.id);
              if (data.potvrda == "da")
              {
                  if (data.kod == korisnik.validacija)
                  {
                      korisnik.validacija = 0;
                      _context.SaveChanges();
                      return 1;
                  }
                  else return 0;
              }
              else if (data.potvrda == "ne")
              {
                  _context.korisnik.Remove(korisnik);
                  _context.SaveChanges();
              }

              return 0;
          }
          */
            return 0;

        }

        public Korisnik vratiUloguKorisnika(long idKorisnika)
        {
            var korisnik = _context.korisnik.FirstOrDefault(k => k.id == idKorisnika);
            korisnik.uloga = "korisnik";
            _context.SaveChanges();
            return korisnik;
        }

        public void dodajOcenu(PrihvatanjeIdKorisnika korisnik)
        {
            var kor = _context.korisnik.FirstOrDefault(k => k.id == korisnik.idKorisnika);
            kor.ocenaAplikacije = korisnik.ocena;
            _context.SaveChanges();
        }
    }
}
