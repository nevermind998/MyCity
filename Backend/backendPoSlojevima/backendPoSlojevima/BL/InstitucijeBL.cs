using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using backendPoSlojevima.BL.Interfaces;
using backendPoSlojevima.DAL.Interfaces;
using backendPoSlojevima.Models;

namespace backendPoSlojevima.BL
{
    public class InstitucijeBL : IInstitucijeBL
    {
        private readonly IInstitucijeDAL _IInstitucijeDAL;
        private readonly IKorisnikBL _IKorisnikBL;
        private List<Korisnik> institucije;

        public InstitucijeBL (IInstitucijeDAL IInstitucijeDAL, IKorisnikBL IKorisnikBL)
        {
            _IInstitucijeDAL = IInstitucijeDAL;
            _IKorisnikBL = IKorisnikBL;
            institucije = _IInstitucijeDAL.getAllInstitucije();
        }
        public void deleteInstitucijeByIdInstitucije(long idInstitucije)
        {
            var institucija = getInstitucijuByIdInsititucije(idInstitucije);
            _IInstitucijeDAL.deleteInstituciju(institucija);
        }



        public void dodajProfilnuSlikuInstituciji(PrihvatanjeSlike slika, String token)
        {
           
            _IInstitucijeDAL.dodajProfilnuSlikuInstituciji(slika,token);
            
        }

       

        public List<Korisnik> getAllInstitucije()
        {
            return _IInstitucijeDAL.getAllInstitucije();
        }

        public List<Korisnik> getInstitucijeByFilter(string data)
        {
            IEnumerable<Korisnik> institucijeByFilter = institucije.Where(k => k.uloga == "institucija" && ( k.username.ToLower().Contains(data.ToLower()) || k.ime.ToLower().Contains(data.ToLower())) );
            return institucijeByFilter.ToList();
        }

        public Korisnik getInstitucijuByIdInsititucije(long idInstitucije)
        {
            return institucije.FirstOrDefault(i => i.id == idInstitucije);
        }

        public int izmeniPodatke(AzuriranjeInstitucije podataka, string token)
        {
            var institucija = this.getInstitucijuByIdInsititucije(podataka.korisnik.id);
            return _IInstitucijeDAL.izmeniPodatke(podataka, institucija, token);
        }

        public KorisnikSaGradovima LoginCheck(Korisnik k)
        {
            var check = _IInstitucijeDAL.LoginCheck(k);
            if (check == null) return null;
            check = _IInstitucijeDAL.dodajTokenKorisniku(check);
            var korisnik = _IKorisnikBL.convertKorisnika(check);
            return korisnik;
            
        }

        public long saveInstituciju(Korisnik data)
        {
            return _IInstitucijeDAL.saveInstituciju(data);
        }
        public long proveraInstitucije(Korisnik data)
        {
            return _IInstitucijeDAL.proveraInstitucije(data);
        }

        public void saveProfilImage(PrihvatanjeSlike slika)
        {
            _IInstitucijeDAL.saveProfilImage(slika);
        }

        public Korisnik unistiToken(long idInstitucije)
        {
            var institucija = getInstitucijuByIdInsititucije(idInstitucije);
            return _IInstitucijeDAL.unistiToken(institucija);
        }
    }
}
