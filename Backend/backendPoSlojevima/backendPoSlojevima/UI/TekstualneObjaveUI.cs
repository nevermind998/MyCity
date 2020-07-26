using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using backendPoSlojevima.UI.Interfaces;
using backendPoSlojevima.BL.Interfaces;
using backendPoSlojevima.Models;

namespace backendPoSlojevima.UI
{
    public class TekstualneObjaveUI : ITekstualneObjaveUI
    {
        private readonly ITekstualneObjaveBL  _ITekstualneObjaveBL;

        public TekstualneObjaveUI( ITekstualneObjaveBL ITekstualneObjaveBL)
        {
             _ITekstualneObjaveBL = ITekstualneObjaveBL;
        }

        public void deleteTekstualnuObjavuByIdKorisnika(PrihvatanjeIdKorisnika korisnika)
        {
            var idKorisnika = korisnika.idKorisnika;
            _ITekstualneObjaveBL.deleteTekstualnuObjavuByIdKorisnika(idKorisnika);
        }

        public void deleteTekstualnuObjavuByIdObjave(PrihvatanjeIdObjave objave)
        {
            var idObjave = objave.idObjave;
            _ITekstualneObjaveBL.deleteTekstualnuObjavuByIdObjave(idObjave);
        }

        public List<TekstualneObjave> getAllTekstualneObjave()
        {
            return _ITekstualneObjaveBL.getAllTekstualneObjave();
        }

        public TekstualneObjave getTekstualnaObjavaByObjavaId(long idObjave)
        {
            return _ITekstualneObjaveBL.getTekstualnuObjavaByObjavaId(idObjave);
        }

       

        public List<TekstualneObjave> getTekstualneObjaveByIdKorisnika(PrihvatanjeIdKorisnika korisnika)
        {
            var idKorisnika = korisnika.idKorisnika;
            return _ITekstualneObjaveBL.getTekstualneObjaveByIdKorisnika(idKorisnika);
        }

        public void izmenaTekstualneObjave(TekstualneObjave objava)
        {
            _ITekstualneObjaveBL.izmenaTekstualneObjave(objava);
        }

        public void saveTekstualnuObjavu(String text)
        {
            _ITekstualneObjaveBL.saveTekstualnuObjavu(text);
        }
    }
}
