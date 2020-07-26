using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using backendPoSlojevima.BL.Interfaces;
using backendPoSlojevima.DAL.Interfaces;
using backendPoSlojevima.Models;

namespace backendPoSlojevima.BL
{
    public class ObjaveKategorijeBL : IObjaveKategorijeBL
    {
        private readonly IObjaveKategorijaDAL _IObjaveKategorijaDAL;
        private readonly List<ObjaveKategorije> objaveKategorije;
        public ObjaveKategorijeBL(IObjaveKategorijaDAL IObjaveKategorijaDAL )
        {
            _IObjaveKategorijaDAL = IObjaveKategorijaDAL;
            objaveKategorije = _IObjaveKategorijaDAL.getAllObjaveKategorije();
        }

        public void dodajObjaviKategoriju(PrihvatanjeObjave objava)
        {
            _IObjaveKategorijaDAL.dodajObjaviKategoriju(objava);
        }

        public List<ObjaveKategorije> getAllObjaveKategorije()
        {
            return _IObjaveKategorijaDAL.getAllObjaveKategorije();
        }

        public List<KategorijeProblema> getKategorijeByIdObjave(long idObjave)
        {
            return _IObjaveKategorijaDAL.getKategorijeByIdObjave(idObjave);

        }

        public List<Objave> getObjaveByIdKategorije(long idKategorije)
        {
            if (idKategorije == 0) return objaveKategorije.Select(o => o.objava).Distinct().ToList();
            return objaveKategorije.Where(o => o.KategorijaID == idKategorije).Select(o => o.objava).Distinct().ToList();
        }
    }
}
