using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using backendPoSlojevima.BL.Interfaces;
using backendPoSlojevima.Models;
using backendPoSlojevima.UI.Interfaces;

namespace backendPoSlojevima.UI
{
    public class InstitucijeUI : IInstitucijeUI
    {
        private readonly IInstitucijeBL _IInstitucijeBL;
        public InstitucijeUI(IInstitucijeBL IInstitucijeBL)
        {
            _IInstitucijeBL = IInstitucijeBL;
        }

        public void deleteInstitucijeByIdInstitucije(long idInstitucije)
        {
            _IInstitucijeBL.deleteInstitucijeByIdInstitucije(idInstitucije);
        }

        public void dodajProfilnuSlikuInstituciji(PrihvatanjeSlike slika, String token)
        {

            _IInstitucijeBL.dodajProfilnuSlikuInstituciji(slika, token);

        }


        public List<Korisnik> getAllInstitucije()
        {
            return _IInstitucijeBL.getAllInstitucije();
        }

        public List<Korisnik> getInstitucijeByFilter(string data)
        {
            return _IInstitucijeBL.getInstitucijeByFilter(data);
        }

        public Korisnik getInstitucijuByIdInsititucije(long idInstitucije)
        {
            return _IInstitucijeBL.getInstitucijuByIdInsititucije(idInstitucije);
        }

        public int izmeniPodatke(AzuriranjeInstitucije institucije, string token)
        {
            return _IInstitucijeBL.izmeniPodatke(institucije, token);
        }

        public KorisnikSaGradovima LoginCheck(Korisnik k)
        {
            return _IInstitucijeBL.LoginCheck(k);
        }

        public long saveInstituciju(Korisnik data)
        {
            return _IInstitucijeBL.saveInstituciju(data);
        }
        public long proveraInstitucije(Korisnik data)
        {
            return _IInstitucijeBL.proveraInstitucije(data);
        }


        public void saveProfilImage(PrihvatanjeSlike slika)
        {
            _IInstitucijeBL.saveProfilImage(slika);
        }

        public Korisnik unistiToken(PrihvatanjeIdInstitucije institucija)
        {
            return _IInstitucijeBL.unistiToken(institucija.idInstitucije);
        }
    }
}
