using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using backendPoSlojevima.Models;

namespace backendPoSlojevima.DAL.Interfaces
{
    public interface  IObjaveKategorijaDAL
    {

        List<ObjaveKategorije> getAllObjaveKategorije();
        void dodajObjaviKategoriju(PrihvatanjeObjave objava);
        public List<KategorijeProblema> getKategorijeByIdObjave(long idObjave);

    }
}
