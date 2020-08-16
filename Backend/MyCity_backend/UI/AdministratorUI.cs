using backendPoSlojevima.BL.Interfaces;
using backendPoSlojevima.Models;
using backendPoSlojevima.UI.Interfaces;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace backendPoSlojevima.UI
{
    public class AdministratorUI : IAdministratorUI
    {
        private readonly IAdministratorBL _IAdministratorBL;
        private readonly IGradKorisniciUI _IGradKorisniciUI;

        public AdministratorUI(IAdministratorBL IAdministratorBL, IGradKorisniciUI IGradKorisniciUI)
        {
            _IAdministratorBL = IAdministratorBL;
            _IGradKorisniciUI = IGradKorisniciUI;
        }

        public Korisnik getAdminById(long idKorisnika)
        {
            return _IAdministratorBL.getAdminById(idKorisnika);
                
        }

        public List<Korisnik> getAllAdministrator()
        {
            return _IAdministratorBL.getAllAdministrator();
        }

        public KorisnikSaGradovima LoginCheck(Korisnik admin)
        {

            KorisnikSaGradovima korisnik = _IAdministratorBL.LoginCheck(admin);
            if (korisnik == null) return null;
            korisnik.gradovi = _IGradKorisniciUI.getAllGradoveByIdKorisnika(admin.id);
            return korisnik;
        }

        public Korisnik odjavaKorisnika(long idKorisnik)
        {
            return _IAdministratorBL.odjavaKorisnika(idKorisnik);
        }
    }
}
