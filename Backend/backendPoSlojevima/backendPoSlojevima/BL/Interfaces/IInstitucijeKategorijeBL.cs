using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using backendPoSlojevima.Models;

namespace backendPoSlojevima.BL.Interfaces
{
    public interface IInstitucijeKategorijeBL
    {
        List<InstitucijeKategorije> getAllInstitucijeKategorije();
        void dodajInstitucijiKategoriju(PrihvatanjeKategorije data);
        List<Korisnik> getInstitucijeByIdKategorije(long idInstitucije);
        List<long> getKategorijeByIdInstitucije(long idInstitucije);
        public int izmeniKategorijeZaKorisnika(long idKorisnika, List<long> kategorije);
    }
}
