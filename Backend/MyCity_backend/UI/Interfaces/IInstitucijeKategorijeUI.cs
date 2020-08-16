using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using backendPoSlojevima.Models;


namespace backendPoSlojevima.UI.Interfaces
{
    public interface IInstitucijeKategorijeUI
    {
        List<InstitucijeKategorije> getAllInstitucijeKategorije();
        void dodajInstitucijiKategoriju(PrihvatanjeKategorije data);
        List<Korisnik> getInstitucijeByIdKategorije(long idInstitucije);
        List<KategorijeProblema> getKategorijeByIdInstitucije(long idInstitucije);
        public int izmeniKategorijeZaKorisnika(long idKorisnika, List<long> kategorije);
    }
}
