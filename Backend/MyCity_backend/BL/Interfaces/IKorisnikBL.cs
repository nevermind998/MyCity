using backendPoSlojevima.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace backendPoSlojevima.BL.Interfaces
{
    public interface IKorisnikBL
    {
        List<Korisnik> getAllKorisnik();
        KorisnikSaGradovima LoginCheck(Korisnik k);
        Korisnik saveKorisnik(Korisnik data);
        public long proveraKorisnika(Korisnik korisnik);
        void saveProfilImage(PrihvatanjeSlike slika,String token);
        Korisnik dodajProfilnuSlikuKorisniku(long idKorisnika);
        Korisnik getKorisnikaById(long idKorisnika);
        List<Korisnik> getKorisnikByFilter(String data);
        void deleteKorisnikaById(long idKorisnika,String token);
        public int deleteKorisnikaByAdmin(long idKorisnik,String token);
        Korisnik odjavaKorisnika(long idKorisnik,String token);
        Korisnik postaviAdmina(long idAdmin);
        int izmeniPodatke(AzuriranjeKorisnika data,String token);
        public List<KorisnikSaGradovima> getAllKorisnikGrad();
        public List<Korisnik> top10PoPoenima();
        public KorisnikSaGradovima convertKorisnika(Korisnik k);
        OcenaAplikacije ocenaAplikacije();
        public void oduzmiPoeneKorisniku(PrihvatanjePoena poeni);
        public void dodajPoeneKorisniku(PrihvatanjePoena poeni);
        public List<Boje> getBoje();
        public Boje getBojeById(long idBoje);
        public int proveraKoda(PrihvatanjeKoda data);
        public void zaboravljenaSifra(ZaboravljenaSifra data);
        public Korisnik vratiUloguKorisnika(long idKorisnika);

        public void dodajOcenu(PrihvatanjeIdKorisnika korisnik);

    }
}
