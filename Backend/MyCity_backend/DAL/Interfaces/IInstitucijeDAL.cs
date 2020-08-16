using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using backendPoSlojevima.Models;

namespace backendPoSlojevima.DAL.Interfaces
{
    public interface IInstitucijeDAL
    {
        List<Korisnik> getAllInstitucije();
        long saveInstituciju(Korisnik data);
        long proveraInstitucije(Korisnik data);
        void saveProfilImage(PrihvatanjeSlike slika);
        public void dodajProfilnuSlikuInstituciji(PrihvatanjeSlike slika, String token);
        public void deleteInstituciju(Korisnik institucija);
        public Korisnik dodajTokenKorisniku(Korisnik institucija);
        public Korisnik unistiToken(Korisnik institucija);
        int izmeniPodatke(AzuriranjeInstitucije podatak, Korisnik institucija, string token);
        public Korisnik LoginCheck(Korisnik k);

        //  void izmeniPodatke(AzuriranjeKorisnika data);
    }
}
