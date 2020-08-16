using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using backendPoSlojevima.Models;

namespace backendPoSlojevima.DAL.Interfaces
{
    public interface IGradKorisniciDAL
    {
        List<GradKorisnici> getAllGradKorisnici();
        void dodajGradKorisnika(long idKorisnika, long idGrada);
       
        void  dodajViseGradovaZaKorisnika(long idKorisnika, List<long> idGrada);
        void izmeniGradoveZaKorisnika(long idKorisnika, List<long> nizGradova);
        public void deleteGradoveZaKorisnika(long idKorisnika);
    }
}
