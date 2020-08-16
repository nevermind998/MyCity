using backendPoSlojevima.BL.Interfaces;
using backendPoSlojevima.DAL.Interfaces;
using backendPoSlojevima.Models;
using Microsoft.Extensions.Configuration;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace backendPoSlojevima.BL
{
    public class KorisnikBL : IKorisnikBL
    {
        private readonly IKorisnikDAL _IKorisnikDAL;
        private readonly List<Korisnik> korisnici;

        public KorisnikBL(IKorisnikDAL IKorisnikDAL)
        {
            _IKorisnikDAL = IKorisnikDAL;
            korisnici = _IKorisnikDAL.getAllKorisnik();

        }

        public int deleteKorisnikaByAdmin(long idKorisnik, String token)
        {
            var korisnik = this.getKorisnikaById(idKorisnik);
            return _IKorisnikDAL.deleteKorisnikaByAdmin(korisnik, token);
        }


        public void deleteKorisnikaById(long idKorisnika, String token)
        {
            Korisnik korisnik = this.getKorisnikaById(idKorisnika);
            _IKorisnikDAL.deleteKorisnika(korisnik, token);
        }

        public Korisnik dodajProfilnuSlikuKorisniku(long idKorisnika)
        {
            Korisnik korisnik = getKorisnikaById(idKorisnika);
            _IKorisnikDAL.dodajProfilnuSlikuKorisniku(korisnik);
            korisnik = this.getKorisnikaById(idKorisnika);
            return korisnik;
        }

        public List<Korisnik> getAllKorisnik()
        {
            return _IKorisnikDAL.getAllKorisnik();
        }

        public Korisnik getKorisnikaById(long idKorisnika)
        {
            return _IKorisnikDAL.getKorisnikaById(idKorisnika);

        }

        public List<Korisnik> getKorisnikByFilter(string data)
        {
            return _IKorisnikDAL.getKorisnikByFilter(data);
        }


        public int izmeniPodatke(AzuriranjeKorisnika data, String token)
        {
            var korisnik = this.getKorisnikaById(data.korisnik.id);
            return _IKorisnikDAL.izmeniPodatke(data, korisnik, token);
        }

        public KorisnikSaGradovima LoginCheck(Korisnik k)
        {
            var check = _IKorisnikDAL.LoginCheck(k);
            if (check == null)
            {
                return null;
            }
            KorisnikSaGradovima korisnik = new KorisnikSaGradovima();
            korisnik = this.convertKorisnika(check);
            return korisnik;
        }

        public List<KorisnikSaGradovima> getAllKorisnikGrad()
        {
            List<KorisnikSaGradovima> lista = new List<KorisnikSaGradovima>();
            foreach (var korisnik in korisnici)
            {
                KorisnikSaGradovima convert = this.convertKorisnika(korisnik);
                lista.Add(convert);
            }
            return lista;
        }
        public KorisnikSaGradovima convertKorisnika(Korisnik k)
        {
            KorisnikSaGradovima korisnik = new KorisnikSaGradovima();
            korisnik.id = k.id;
            korisnik.ime = k.ime;
            korisnik.prezime = k.prezime;
            korisnik.email = k.email;
            korisnik.biografija = k.biografija;
            korisnik.Token = k.Token;
            korisnik.poeni = k.poeni;
            korisnik.uloga = k.uloga;
            korisnik.urlSlike = k.urlSlike;
            korisnik.username = k.username;
            korisnik.password = k.password;
            korisnik.ocenaAplikacije = k.ocenaAplikacije;
            return korisnik;
        }
        public Korisnik odjavaKorisnika(long idKorisnik, String token)
        {

            var korisnik = getKorisnikaById(idKorisnik);
            if (korisnik != null)
            {
                return _IKorisnikDAL.unistiToken(korisnik, token);
            }

            return null;
        }

        public Korisnik postaviAdmina(long idAdmin)
        {
            var admin = getKorisnikaById(idAdmin);
            if (admin != null)
            {
                return _IKorisnikDAL.postaviAdmina(admin);
            }
            return null;
        }



        public Korisnik saveKorisnik(Korisnik data)
        {
            return _IKorisnikDAL.saveKorisnik(data);
        }
        public long proveraKorisnika(Korisnik korisnik)
        {
            return _IKorisnikDAL.proveraKorisnika(korisnik);
        }

        public void saveProfilImage(PrihvatanjeSlike slika, String token)
        {
            _IKorisnikDAL.saveProfilImage(slika, token);
        }

        public OcenaAplikacije ocenaAplikacije()
        {
            OcenaAplikacije ocena = new OcenaAplikacije();
            var ukupnaOcena = korisnici.Sum(o => o.ocenaAplikacije);
            ocena.glasalo = korisnici.Where(o => o.ocenaAplikacije != -1).Count();
            if (ocena.glasalo > 0)
            {
                ocena.prosecnaOcena = ukupnaOcena / ocena.glasalo;
            }
            else
            {
                ocena.prosecnaOcena = 0;
            }

            ocena.brojKorisnika = korisnici.Count();
            ocena.nijeGlasalo = ocena.brojKorisnika - ocena.glasalo;
            return ocena;
        }

        public List<Korisnik> top10PoPoenima()
        {
            return korisnici.OrderByDescending(k => k.poeni).Take(10).ToList();

        }

        public void oduzmiPoeneKorisniku(PrihvatanjePoena poeni)
        {
            _IKorisnikDAL.oduzmiPoeneKorisniku(poeni);
        }

        public void dodajPoeneKorisniku(PrihvatanjePoena poeni)
        {
            _IKorisnikDAL.dodajPoeneKorisniku(poeni);
        }


        public List<Boje> getBoje()
        {
            return _IKorisnikDAL.getBoje();
        }
        public Boje getBojeById(long idBoje)
        {
            return _IKorisnikDAL.getBojeById(idBoje);
        }

        public int proveraKoda(PrihvatanjeKoda data)
        {
            return _IKorisnikDAL.proveraKoda(data);
        }
        public void zaboravljenaSifra(ZaboravljenaSifra data)
        {
            _IKorisnikDAL.zaboravljenaSifra(data);
        }

        public Korisnik vratiUloguKorisnika(long idKorisnika)
        {
            return _IKorisnikDAL.vratiUloguKorisnika(idKorisnika);
        }

        public void dodajOcenu(PrihvatanjeIdKorisnika korisnik)
        {
            _IKorisnikDAL.dodajOcenu(korisnik);
        }
    }
}
