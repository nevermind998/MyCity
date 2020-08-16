using backendPoSlojevima.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace backendPoSlojevima.DAL.Interfaces
{
    public interface IKorisnikDAL
    {
        List<Korisnik> getAllKorisnik();
        Korisnik saveKorisnik(Korisnik data);
        public long proveraKorisnika(Korisnik korisnik);
        public void deleteKorisnika(Korisnik korisnik, String token);
        public int deleteKorisnikaByAdmin(Korisnik korisnik, String token);
        void saveProfilImage(PrihvatanjeSlike slika,String token);
        void dodajProfilnuSlikuKorisniku(Korisnik korisnik);
        int izmeniPodatke(AzuriranjeKorisnika data, Korisnik korisnik,String token);
        Korisnik dodajTokenKorisniku(Korisnik korisnik);
         Korisnik unistiToken(Korisnik korisnik, String token);
        Korisnik postaviAdmina(Korisnik admin);
        int proveraIdKorisnika(long idKorisnika);
        public Korisnik LoginCheck(Korisnik k);
        public void oduzmiPoeneKorisniku(PrihvatanjePoena poeni);
        public void dodajPoeneKorisniku(PrihvatanjePoena poeni);

        public List<Korisnik> getKorisnikByFilter(string data);
        public List<Boje> getBoje();
        public Boje getBojeById(long idBoje);

        public int proveraKoda(PrihvatanjeKoda data);
        public void zaboravljenaSifra(ZaboravljenaSifra data);
        Korisnik getKorisnikaById(long idKorisnika);

        public Korisnik vratiUloguKorisnika(long idKorisnika);

        public void dodajOcenu(PrihvatanjeIdKorisnika korisnik);




    }
}
