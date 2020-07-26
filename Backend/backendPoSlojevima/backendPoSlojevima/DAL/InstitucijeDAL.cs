using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Threading.Tasks;
using backendPoSlojevima.DAL.Interfaces;
using backendPoSlojevima.Data;
using backendPoSlojevima.Models;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Configuration;
using MailKit.Net.Smtp;
using MimeKit;
using System.IO;

namespace backendPoSlojevima.DAL
{
    public class InstitucijeDAL : IInstitucijeDAL
    {
        private readonly ApplicationDbContext _context;
        private readonly IWebHostEnvironment _IWebHostEnvironment;
        private readonly IConfiguration _configuration;
        private readonly AuthRepository _auth;


        public InstitucijeDAL(ApplicationDbContext context, IWebHostEnvironment IWebHostEnvironment, IConfiguration configuration)
        {
            _context = context;
            _IWebHostEnvironment = IWebHostEnvironment;
            _configuration = configuration;
            _auth = new AuthRepository(configuration);
        }
        public void deleteInstituciju(Korisnik institucija)
        {
            if (institucija == null) return;
            _context.korisnik.Remove(institucija);
            _context.SaveChanges();
        }



        public List<Korisnik> getAllInstitucije()
        {
            return _context.korisnik.Where(k => k.uloga == "institucija").ToList();
        }

        public long saveInstituciju(Korisnik korisnik)
        {
            Korisnik check = _context.korisnik.FirstOrDefault(k => k.username == korisnik.username);

            if (check != null) return -1; //we have this username
            korisnik.uloga = "institucija";
            korisnik.poeni = 0;
            korisnik.ocenaAplikacije = -1;
            long id = _context.korisnik.Count();
            if (id == 0)
            {
                id = 1;
            }
            else
            {
                id = _context.korisnik.Max(o => o.id) + 1;
            }
            korisnik.id = id;
            _context.korisnik.Add(korisnik);
            _context.SaveChanges();
            return id;


        }

        public long proveraInstitucije(Korisnik data)
        {
            data.username = data.username.Trim();
           Korisnik check = _context.korisnik.FirstOrDefault(k => k.username == data.username);

            if (check != null) return -1; //we have this username
           Korisnik check1 = _context.korisnik.FirstOrDefault(k => k.email == data.email);
            if (check1 != null) return -2; //we have this email
            return 1;

        }


        public void dodajProfilnuSlikuInstituciji(PrihvatanjeSlike slika, String token)
        {
            var korisnik = _context.korisnik.FirstOrDefault(k => k.Token == token);
            var id = korisnik.id;
            korisnik.urlSlike = "institucije//profilImage//image" + id + ".jpg";
            var imageDataByteArray = Convert.FromBase64String(slika.urlSlike);
            String webRoot = _IWebHostEnvironment.WebRootPath;
            var PathWithFolderName = System.IO.Path.Combine(webRoot, korisnik.urlSlike);
            System.IO.File.WriteAllBytes(PathWithFolderName, imageDataByteArray);
            _context.SaveChanges();
        }

        public void saveProfilImage(PrihvatanjeSlike slika)
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
            var urlSlike = "institucije//profilImage//image" + id + ".jpg";  
            String webRoot = _IWebHostEnvironment.WebRootPath;
            var PathWithFolderName = System.IO.Path.Combine(webRoot, urlSlike);
            var stream = System.IO.File.Create(PathWithFolderName);
            slika.slika.CopyTo(stream);
        }

        public Korisnik dodajTokenKorisniku(Korisnik korisnik)
        {
            var response = _auth.CreateToken(korisnik);
            korisnik.Token = response;
            _context.korisnik.Update(korisnik);
            _context.SaveChanges();
            return korisnik;
        }

        public Korisnik unistiToken(Korisnik institucija)
        {
            institucija.Token = null;
            _context.korisnik.Update(institucija);
            _context.SaveChanges();
            return institucija;

        }
        private int checkUserName(String username, long id)
        {
            var check = _context.korisnik.FirstOrDefault(k => k.username == username && k.id != id);

            if (check != null) return 1;
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



        public int izmeniPodatke(AzuriranjeInstitucije podatak,Korisnik institucija, string token)
        {
            int provera = this.proveraKorisnika(institucija.id, token);
            if (provera == 0)
            {
                return 1;
            }
            Korisnik data = podatak.korisnik;
            if (data.username != null)
            {
                int ind = this.checkUserName(data.username, data.id);
                if (ind == 1) return -1; //ne valja username
                institucija.username = data.username;
            };
            if (data.password != null)
            {
                var ind = _context.korisnik.FirstOrDefault(k => k.id == data.id && data.password == k.password);
                if (ind == null) return -2; //ne valja sifra
                institucija.password = podatak.newPassword;
            }
            if (data.ime != null)
            {
                institucija.ime = data.ime;
            }
            if (data.prezime != null)
            {
                institucija.prezime = data.prezime;
            }


            if (data.email != null)
            {
                institucija.email = data.email;
            }
            if (data.biografija != null)
            {
                institucija.biografija = data.biografija;
            }
            _context.SaveChanges();
            return 1; //sve okl
        }

        public Korisnik LoginCheck(Korisnik k)
        {
            k.username = k.username.Trim();
            var check = _context.korisnik.FirstOrDefault(c => c.username.Equals(k.username) && c.password.Equals(k.password) && c.uloga == "institucija");
            if (check == null) return null;
            check = this.dodajTokenKorisniku(check);
            return check;
        }
    }
}
