using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using backendPoSlojevima.BL.Interfaces;
using backendPoSlojevima.Models;
using backendPoSlojevima.UI.Interfaces;

namespace backendPoSlojevima.UI
{
    public class SlikeUI : ISlikeUI
    {
        private readonly ISlikeBL _ISlikeBL;

        public SlikeUI(ISlikeBL ISlikeBL)
        {
            _ISlikeBL = ISlikeBL;
        }

        

        public void saveImage(PrihvatanjeSlike slika)
        {
             _ISlikeBL.saveImage(slika);
        }

        public List<Slike> getImages()
        {
            return _ISlikeBL.getImages();
        }

        public Slike getSlikuByIdObjave(long idObjave)
        {
            return _ISlikeBL.getSlikuByIdObjave(idObjave);
        }

        public void saveOpisSlike(PrihvatanjeOpisaSlike opis)
        {
            _ISlikeBL.saveOpisSlike(opis);
        }

        public void deleteSlikuByIdObjave(long idObjave)
        {
            _ISlikeBL.deleteSlikuByIdObjave(idObjave);
        }

        public void deleteSlikeByIdKorisnika(long idKorisnika)
        {
            _ISlikeBL.deleteSlikeByIdKorisnika(idKorisnika);
        }

        public List<Slike> getSlikeByIdKorisnika(long idKorisnika)
        {
            return _ISlikeBL.getSlikeByIdKorisnika(idKorisnika);
        }

        public void izmenaSlike(Slike slika)
        {
            _ISlikeBL.izmenaSlike(slika);
        }
    }
}
