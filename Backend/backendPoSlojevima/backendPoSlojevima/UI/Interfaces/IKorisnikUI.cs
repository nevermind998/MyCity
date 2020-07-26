using backendPoSlojevima.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace backendPoSlojevima.UI.Interfaces
{
    public interface IKorisnikUI
    {
        List<Korisnik> getAllKorisnik();
        KorisnikSaGradovima LoginCheck(Korisnik k);
        Korisnik saveKorisnik(Korisnik data);
        public long proveraKorisnika(Korisnik korisnik);
        void saveProfilImage(PrihvatanjeSlike slika, String token);
        public Korisnik dodajProfilnuSlikuKorisniku(PrihvatanjeIdKorisnika korisnik);
        Korisnik getKorisnikaById(long idKorisnika);
        List<KorisnikSaGradovima> getKorisnikByFilter(String data);
        void deleteKorisnikaById(PrihvatanjeIdKorisnika idKorisnika,String token);
        public int deleteKorisnikaByAdmin(long idKorisnik,String token);
        Korisnik odjavaKorisnika(PrihvatanjeIdKorisnika korisnik, String token);
        Korisnik postaviAdmina(PrihvatanjeIdKorisnika admin);
        List<long> prikaziKorisnikaZaAdmina(long odBroja, long doBroja, String trazi,List<Korisnik> korisnici);
        List<KorisnikZaAdmina> pretragaKorisnikZaAdmina(PretragaKorisnika korisnika);
        int izmeniPodatke(AzuriranjeKorisnika data, string token);
       /* List<Korisnik> vratiKorisnikeByReportaObjava(PrihvatanjeIdKorisnika korisnik);
        List<Korisnik> vratiKorisnikeByReportaKomentara(PrihvatanjeIdKorisnika korisnik);*/
        public List<KorisnikSaGradovima> getAllKorisnikGrad();
        public List<Korisnik> top10PoPoenima();
        KorisnikSaGradovima posaljiKorisnika(long idKorisnika);
        OcenaAplikacije ocenaAplikacije();
        public void oduzmiPoeneKorisniku(PrihvatanjePoena poeni);
        public void dodajPoeneKorisniku(PrihvatanjePoena poeni);
        public List<Boje> getBoje();
        public Boje getBojeById(long idBoje);
        public KorisnikSaGradovima convertKorisnika(Korisnik k);
        public int proveraKoda(PrihvatanjeKoda data);
        Gejmifikacija getBojeZaKorisnika(PrihvatanjeIdKorisnika korisnik);
        public void zaboravljenaSifra(ZaboravljenaSifra data);
        public Korisnik vratiUloguKorisnika(long idKorisnika);
        public void dodajOcenu(PrihvatanjeIdKorisnika korisnik);
    }
}
