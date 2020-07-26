using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using backendPoSlojevima.Models;

namespace backendPoSlojevima.BL.Interfaces
{
    public interface IGradKorisniciBL 
    {
        List<GradKorisnici> getAllGradKorisnici();
        void dodajGradKorisnika(long idKorisnika, long idGrada);
        void dodajViseGradovaZaKorisnika(long idKorisnika, List<long> idGrada);
        void izmeniGradoveZaKorisnika(long idKorisnika, List<long> nizGradova);
        public void deleteGradoveZaKorisnika(long idKorisnika);
        List<long> getGradoveByIdKorisnika(long idKorisnika);
        List<long> getKorinsikeByIdGrada(long idGrada);
        public List<GradKorisnici> getAllGradoveByIdKorisnika(long idKorisnika);
        public List<Korisnik> getListuKorinsikaByIdGrada(long idGrada);
        List<Korisnik> getGradjaneByIdGrada(long idGrada);
        List<TopGradovi> top10Gradova();


    }
}
