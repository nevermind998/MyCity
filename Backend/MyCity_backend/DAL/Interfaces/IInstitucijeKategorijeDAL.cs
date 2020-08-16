using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using backendPoSlojevima.Models;


namespace backendPoSlojevima.DAL.Interfaces
{
    public interface IInstitucijeKategorijeDAL
    {
        List<InstitucijeKategorije> getAllInstitucijeKategorije();
        void dodajInstitucijiKategoriju(PrihvatanjeKategorije data);
        public int izmeniKategorijeZaKorisnika(long idKorisnika, List<long> kategorije);
        public void deleteKategorijeZaKorisnika(long idKorisnika);
        void dodajViseKategorijaZaKorisnika(long idKorisnika, List<long> idGrada);
    }
}
