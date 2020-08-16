using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using backendPoSlojevima.Models;

namespace backendPoSlojevima.UI.Interfaces
{
    public interface IGradKorisniciUI
    {
        List<GradKorisnici> getAllGradKorisnici();
        void dodajKorisnikaZaGradove(PrihvatanjeKorisnika data);
        void izmeniGradoveZaKorisnika(long idKorisnika, List<long> nizGradova);
        public void deleteGradoveZaKorisnika(long idKorisnika);
        List<long> getGradoveByIdKorisnika(long idKorisnika);
        List<long> getKorinsikeByIdGrada(long idGrada);
        public List<Grad> getAllGradoveByIdKorisnika(long idKorisnika);
        public List<Korisnik> getListuKorinsikaByIdGrada(long idGrada);
        List<Korisnik> getGradjaneByIdGrada(long idGrada);
        List<TopGradovi>  top10Gradova();
        List<StatistikaGradova> brojKorisnikaPoGradovima();



    }
}
