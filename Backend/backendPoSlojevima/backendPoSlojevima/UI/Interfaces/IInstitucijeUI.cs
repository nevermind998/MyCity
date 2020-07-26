using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using backendPoSlojevima.Models;

namespace backendPoSlojevima.UI.Interfaces
{
    public interface IInstitucijeUI
    {
        List<Korisnik> getAllInstitucije();
        KorisnikSaGradovima LoginCheck(Korisnik k);
        long saveInstituciju(Korisnik data);
        long proveraInstitucije(Korisnik data);
        void saveProfilImage(PrihvatanjeSlike slika);
        public void dodajProfilnuSlikuInstituciji(PrihvatanjeSlike slika, String token);
        Korisnik getInstitucijuByIdInsititucije(long idInstitucije);
        List<Korisnik> getInstitucijeByFilter(String data);
        void deleteInstitucijeByIdInstitucije(long idInstitucije);
        public Korisnik unistiToken(PrihvatanjeIdInstitucije idInstuticije);
        int izmeniPodatke(AzuriranjeInstitucije institucije, string token);
    }
}
