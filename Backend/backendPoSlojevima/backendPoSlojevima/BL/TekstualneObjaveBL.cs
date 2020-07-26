using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using backendPoSlojevima.BL.Interfaces;
using backendPoSlojevima.Models;
using backendPoSlojevima.DAL.Interfaces;

namespace backendPoSlojevima.BL
{
    public class TekstualneObjaveBL : ITekstualneObjaveBL
    {
        private readonly ITekstualneObjaveDAL _ITekstualneObjaveDAL;
        private readonly IObjaveBL _IObjaveBL;
        private readonly List<TekstualneObjave> tekstualneObjave;

        public TekstualneObjaveBL(ITekstualneObjaveDAL ITekstualneObjaveDAL, IObjaveBL IObjaveBL)
        {
            _ITekstualneObjaveDAL = ITekstualneObjaveDAL;
            _IObjaveBL = IObjaveBL;
            tekstualneObjave = _ITekstualneObjaveDAL.getAllTekstualneObjave();
        }

        public void deleteTekstualnuObjavuByIdKorisnika(long idKorisnika)
        {
            List<TekstualneObjave> tekstualne_objave = getTekstualneObjaveByIdKorisnika(idKorisnika);
            if (tekstualne_objave != null)
            _ITekstualneObjaveDAL.deleteTekstualneObjave(tekstualne_objave);
            
        }
        
        public void deleteTekstualnuObjavuByIdObjave(long idObjave)
        {
            TekstualneObjave tekstualnaObjava = this.getTekstualnuObjavaByObjavaId(idObjave);
            if (tekstualnaObjava != null)
            _ITekstualneObjaveDAL.deleteTekstualnuObjavu(tekstualnaObjava);
        }

        public List<TekstualneObjave> getAllTekstualneObjave()
        {
            return _ITekstualneObjaveDAL.getAllTekstualneObjave();
        }



        public TekstualneObjave getTekstualnuObjavaByObjavaId(long idObjave)
        {
            return tekstualneObjave.SingleOrDefault(t => t.ObjaveID == idObjave);
        }

        public List<TekstualneObjave> getTekstualneObjaveByIdKorisnika(long idKorisnika)
        {
            List<Objave> objave = _IObjaveBL.getObjaveByIdKorisnika(idKorisnika);
            List<TekstualneObjave> tekstualne = new List<TekstualneObjave>();
            foreach(var objava in objave)
            {
                if (objava.idTipa == 2)
                {
                    var dodaj = this.getTekstualnuObjavaByObjavaId(objava.id);
                    tekstualne.Add(dodaj);
                }
            }
            return tekstualne;
        }

        

        public void saveTekstualnuObjavu(String  text)
        {
             _ITekstualneObjaveDAL.saveTekstualnuObjavu(text);
        }

        public void izmenaTekstualneObjave(TekstualneObjave objava)
        {
            _ITekstualneObjaveDAL.izmenaTekstualneObjave(objava);
        }
    }
}
