using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using backendPoSlojevima.Models;

namespace backendPoSlojevima.UI.Interfaces
{
    public interface IObjaveKategorijeUI
    {
        List<ObjaveKategorije> getAllObjaveKategorije();
        void dodajObjaviKategoriju(PrihvatanjeObjave objava);

        public List<Objave> getObjavuByIdKategorije(long kategorija);
        public List<KategorijeProblema> getKategorijeByIdObjave(long idObjave);


    }
}
