using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using backendPoSlojevima.Models;

namespace backendPoSlojevima.DAL.Interfaces
{
    public interface ISlikeDAL
    {
        void saveImage(PrihvatanjeSlike slika);
        List<Slike> getImages();
        void saveOpisSlike(PrihvatanjeOpisaSlike opis);
        void deleteSlike(List<Slike> slike);
        void deleteSliku(Slike slika);
        void izmenaSlike(Slike slika);

    }
}
