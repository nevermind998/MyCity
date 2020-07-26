using backendPoSlojevima.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace backendPoSlojevima.UI.Interfaces
{
    public interface IAdministratorUI
    {
        List<Korisnik> getAllAdministrator();
        KorisnikSaGradovima LoginCheck(Korisnik admin);
        Korisnik getAdminById(long idKorisnika);
        Korisnik odjavaKorisnika(long idKorisnik);
    }
}
