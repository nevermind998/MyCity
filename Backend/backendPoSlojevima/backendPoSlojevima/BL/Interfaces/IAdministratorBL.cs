using backendPoSlojevima.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace backendPoSlojevima.BL.Interfaces
{
    public interface IAdministratorBL
    {
        List<Korisnik> getAllAdministrator();
        KorisnikSaGradovima LoginCheck(Korisnik admin);
        Korisnik odjavaKorisnika(long idKorisnik);
        Korisnik getAdminById(long idKorisnika);
    }
}
