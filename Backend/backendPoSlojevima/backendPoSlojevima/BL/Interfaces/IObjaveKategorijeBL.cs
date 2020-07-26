using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using backendPoSlojevima.Models;

namespace backendPoSlojevima.BL.Interfaces
{
    public interface IObjaveKategorijeBL
    {
        List<ObjaveKategorije> getAllObjaveKategorije();
        void dodajObjaviKategoriju(PrihvatanjeObjave objava);
        List<Objave> getObjaveByIdKategorije(long idKategorije);
        List<KategorijeProblema> getKategorijeByIdObjave(long idObjave);
    }
}
