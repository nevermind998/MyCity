using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using backendPoSlojevima.BL.Interfaces;
using backendPoSlojevima.DAL.Interfaces;
using backendPoSlojevima.Models;

namespace backendPoSlojevima.BL
{
    public class InstitucijeKategorijeBL : IInstitucijeKategorijeBL
    {
        private readonly IInstitucijeKategorijeDAL _IInstitucijeKategorijeDAL;
        private readonly List<InstitucijeKategorije> institucijeKategorije;

        public InstitucijeKategorijeBL(IInstitucijeKategorijeDAL IInstitucijeKategorijeDAL)
        {
            _IInstitucijeKategorijeDAL = IInstitucijeKategorijeDAL;
            institucijeKategorije = _IInstitucijeKategorijeDAL.getAllInstitucijeKategorije();
        }
        public void dodajInstitucijiKategoriju(PrihvatanjeKategorije data)
        {
            _IInstitucijeKategorijeDAL.dodajInstitucijiKategoriju(data);
        }

        public List<InstitucijeKategorije> getAllInstitucijeKategorije()
        {
            return _IInstitucijeKategorijeDAL.getAllInstitucijeKategorije();
        }

        public List<Korisnik> getInstitucijeByIdKategorije(long idKategorije)
        {
            return institucijeKategorije.Where(i => i.KategorijaID == idKategorije).Select(i => i.institucija).ToList();
        }

        public List<long> getKategorijeByIdInstitucije(long idInstitucije)
        {
            return institucijeKategorije.Where(i => i.InstitucijaID == idInstitucije).Select(i => i.KategorijaID).ToList();
        }

        public int izmeniKategorijeZaKorisnika(long idKorisnika, List<long> kategorije)
        {
            return _IInstitucijeKategorijeDAL.izmeniKategorijeZaKorisnika(idKorisnika, kategorije);
        }
    }
}
