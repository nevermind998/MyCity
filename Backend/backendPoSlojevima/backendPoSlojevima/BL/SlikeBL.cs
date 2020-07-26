using backendPoSlojevima.BL.Interfaces;
using backendPoSlojevima.DAL.Interfaces;
using backendPoSlojevima.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace backendPoSlojevima.BL
{
    public class SlikeBL : ISlikeBL
    {
        private readonly ISlikeDAL _ISlikeDAL;
        private readonly IObjaveBL _IObjaveBL;
        private readonly List<Slike> slike;

        public SlikeBL(ISlikeDAL ISlikeDAL, IObjaveBL IObjaveBL)
        {
            _ISlikeDAL = ISlikeDAL;
            _IObjaveBL = IObjaveBL;
            slike = _ISlikeDAL.getImages();
        }

        public void deleteSlikeByIdKorisnika(long idKorisnika)
        {
            List<Slike> slike = getSlikeByIdKorisnika(idKorisnika);
            if (slike != null)
             _ISlikeDAL.deleteSlike(slike);
        }

        public void deleteSlikuByIdObjave(long idObjave)
        {
            Slike slika = getSlikuByIdObjave(idObjave);
            if(slika != null)
            _ISlikeDAL.deleteSliku(slika);
            
        }

        public List<Slike> getImages()
        {
            return _ISlikeDAL.getImages();
        }

        public List<Slike> getSlikeByIdKorisnika(long idKorisnika)
        {
            List<Objave> objave = _IObjaveBL.getObjaveByIdKorisnika(idKorisnika);
            List<Slike> slike = new List<Slike>();
            foreach (var objava in objave)
            {
                if (objava.idTipa == 1)
                {
                    var dodaj = this.getSlikuByIdObjave(objava.id);
                    slike.Add(dodaj);
                }
            }
            return slike;
        }

        public Slike getSlikuByIdObjave(long idObjave)
        {
            return slike.SingleOrDefault(s => s.ObjaveID == idObjave);
        }

        public void izmenaSlike(Slike slika)
        {
            _ISlikeDAL.izmenaSlike(slika);
        }

        public void saveImage(PrihvatanjeSlike slika)
        {
            _ISlikeDAL.saveImage(slika);
        }

        public void saveOpisSlike(PrihvatanjeOpisaSlike opis)
        {
            _ISlikeDAL.saveOpisSlike(opis);
        }
    }
}
