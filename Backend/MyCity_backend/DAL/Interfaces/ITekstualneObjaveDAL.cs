using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using backendPoSlojevima.Models;

namespace backendPoSlojevima.DAL.Interfaces
{
    public interface ITekstualneObjaveDAL
    {
       
        List<TekstualneObjave> getAllTekstualneObjave();
        void saveTekstualnuObjavu(String text);
        void deleteTekstualneObjave(List<TekstualneObjave> objave);
        void deleteTekstualnuObjavu(TekstualneObjave objava);
        public void izmenaTekstualneObjave(TekstualneObjave objava);
    }
}
