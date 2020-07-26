using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using backendPoSlojevima.Models;

namespace backendPoSlojevima.UI.Interfaces
{
    public interface ITekstualneObjaveUI
    {
        List<TekstualneObjave> getAllTekstualneObjave();
        void saveTekstualnuObjavu(String text);
        TekstualneObjave getTekstualnaObjavaByObjavaId(long idObjave);
        public List<TekstualneObjave> getTekstualneObjaveByIdKorisnika(PrihvatanjeIdKorisnika korisnika);
        void deleteTekstualnuObjavuByIdObjave(PrihvatanjeIdObjave idObjave);
        void deleteTekstualnuObjavuByIdKorisnika(PrihvatanjeIdKorisnika idKorisnika);
        public void izmenaTekstualneObjave(TekstualneObjave objava);
    }
}
