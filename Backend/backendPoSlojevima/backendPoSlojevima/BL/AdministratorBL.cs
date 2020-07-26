using backendPoSlojevima.BL.Interfaces;
using backendPoSlojevima.DAL.Interfaces;
using backendPoSlojevima.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace backendPoSlojevima.BL
{
    public class AdministratorBL : IAdministratorBL
    {
        private readonly IAdministratorDAL _IAdministratorDAL;
        private readonly List<Korisnik> administratori;
        

        public AdministratorBL(IAdministratorDAL IAdministratorDAL)
        {
            _IAdministratorDAL = IAdministratorDAL;
            administratori = _IAdministratorDAL.getAllAdministrator();
        }

        public Korisnik getAdminById(long idKorisnika)
        {
            return _IAdministratorDAL.getAdminById(idKorisnika);
        }

        public List<Korisnik> getAllAdministrator()
        {
            return _IAdministratorDAL.getAllAdministrator();
        }

        public KorisnikSaGradovima LoginCheck(Korisnik admin)
        {
            var check = _IAdministratorDAL.LoginCheck(admin);
            if (check == null)
            {
                return null;
            }
     
            KorisnikSaGradovima korisnik = this.convertKorisnika(check);
            return korisnik;

        }

        public Korisnik odjavaKorisnika(long idKorisnik)
        {

                var korisnik = getAdminById(idKorisnik);
                if (korisnik != null)
                {
                    return _IAdministratorDAL.unistiToken(korisnik);
                }

                return null;
            
        }

        private KorisnikSaGradovima convertKorisnika(Korisnik k)
        {
            KorisnikSaGradovima korisnik = new KorisnikSaGradovima();
            korisnik.id = k.id;
            korisnik.ime = k.ime;
            korisnik.prezime = k.prezime;
            korisnik.biografija = k.biografija;
            korisnik.Token = k.Token;
            korisnik.poeni = k.poeni;
            korisnik.uloga = k.uloga;
            korisnik.urlSlike = k.urlSlike;
            korisnik.username = k.username;
            korisnik.password = k.password;
            return korisnik;
        }
    }
}
