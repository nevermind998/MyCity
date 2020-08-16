using backendPoSlojevima.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace backendPoSlojevima.DAL.Interfaces
{
    public interface IAdministratorDAL
    {
        List<Korisnik> getAllAdministrator();
        Korisnik dodajTokenKorisniku(Korisnik korisnik);
        Korisnik unistiToken(Korisnik korisnik);
        public Korisnik LoginCheck(Korisnik k);
        public Korisnik getAdminById(long idKorisnika);

    }
}
