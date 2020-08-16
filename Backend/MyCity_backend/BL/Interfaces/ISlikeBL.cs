using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using backendPoSlojevima.Models;

namespace backendPoSlojevima.BL.Interfaces
{
    public interface ISlikeBL
    {

        void saveImage(PrihvatanjeSlike data);
        void deleteSlikuByIdObjave(long idObjave);
        void deleteSlikeByIdKorisnika(long idKorisnika);
        public List<Slike> getSlikeByIdKorisnika(long idKorisnika);
        List<Slike> getImages();
        Slike getSlikuByIdObjave(long idObjave);
        void saveOpisSlike(PrihvatanjeOpisaSlike opis);
        void izmenaSlike(Slike slika);
    }
}
