using backendPoSlojevima.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace backendPoSlojevima.UI.Interfaces
{
    public interface ISlikeUI
    {
     
        void saveImage(PrihvatanjeSlike slika);
        void saveOpisSlike(PrihvatanjeOpisaSlike opis);
        void deleteSlikuByIdObjave(long idObjave);
        void deleteSlikeByIdKorisnika(long idKorisnika);
        public List<Slike> getSlikeByIdKorisnika(long idKorisnika);
        List<Slike> getImages();
        Slike getSlikuByIdObjave(long idObjave);
        void izmenaSlike(Slike slika);

    }
}
