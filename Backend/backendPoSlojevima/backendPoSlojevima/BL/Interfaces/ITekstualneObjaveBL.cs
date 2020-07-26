using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using backendPoSlojevima.Models;

namespace backendPoSlojevima.BL.Interfaces
{
    public interface ITekstualneObjaveBL
    {
        List<TekstualneObjave> getAllTekstualneObjave();
        void saveTekstualnuObjavu(String text);
        void deleteTekstualnuObjavuByIdObjave(long idObjave);
        void deleteTekstualnuObjavuByIdKorisnika(long idKorisnika);
        TekstualneObjave getTekstualnuObjavaByObjavaId(long idObjave);
        public List<TekstualneObjave> getTekstualneObjaveByIdKorisnika(long idKorisnika);
        public void  izmenaTekstualneObjave(TekstualneObjave objava);

    }
}
