using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using backendPoSlojevima.BL.Interfaces;
using backendPoSlojevima.DAL.Interfaces;
using backendPoSlojevima.Models;

namespace backendPoSlojevima.BL
{
    public class GradKorisniciBL : IGradKorisniciBL
    {
        private readonly IGradKorisniciDAL _IGradKorisniciDAL;
        private readonly IGradBL _IGradBL;
        private readonly List<GradKorisnici> gradKorisnici;

        public GradKorisniciBL (IGradKorisniciDAL IGradKorisniciDAL, IGradBL IGradBL)
        {
            _IGradKorisniciDAL = IGradKorisniciDAL;
            _IGradBL = IGradBL;
            gradKorisnici = _IGradKorisniciDAL.getAllGradKorisnici();
        }

       

        public void deleteGradoveZaKorisnika(long idKorisnika)
        {
            _IGradKorisniciDAL.deleteGradoveZaKorisnika(idKorisnika);
        }

        public void dodajGradKorisnika(long idKorisnika, long idGrada)
        {
            _IGradKorisniciDAL.dodajGradKorisnika(idKorisnika, idGrada);
        }

        public void dodajViseGradovaZaKorisnika(long idKorisnika, List<long> idGrada)
        {
            _IGradKorisniciDAL.dodajViseGradovaZaKorisnika(idKorisnika, idGrada);
        }

        public List<GradKorisnici> getAllGradoveByIdKorisnika(long idKorisnika)
        {
            return gradKorisnici.Where(g => g.KorisnikID == idKorisnika).ToList();
        }

        public List<Korisnik> getGradjaneByIdGrada(long idGrada)
        {
            return gradKorisnici.Where(g => g.GradID == idGrada && g.korisnik.uloga != "institucija").Select(g => g.korisnik).ToList();
        }

        public List<long> getGradoveByIdKorisnika(long idKorisnika)
        {
            return gradKorisnici.Where(g => g.KorisnikID == idKorisnika).Select(n => n.GradID).ToList();

        }

        public List<long> getKorinsikeByIdGrada(long idGrada)
        {
            return gradKorisnici.Where(g => g.GradID == idGrada).Select(g => g.KorisnikID).ToList();
        }
        public List<Korisnik> getListuKorinsikaByIdGrada(long idGrada)
        {
            return gradKorisnici.Where(g => g.GradID == idGrada).Select(g => g.korisnik).ToList();
        }


        public void izmeniGradoveZaKorisnika(long idKorisnika, List<long> nizGradova)
        {
            _IGradKorisniciDAL.izmeniGradoveZaKorisnika(idKorisnika, nizGradova);
        }

        public List<TopGradovi> top10Gradova()
        {
            List<TopGradovi> listaGradova = new List<TopGradovi>();
            var gradovi = _IGradBL.getAllGradove();
            foreach(var grad in gradovi )
            {
                TopGradovi g = new TopGradovi();
                g.nazivGrada = grad.naziv_grada_lat;
                g.brojPoena = gradKorisnici.Where(gk=> gk.GradID == grad.id).Sum(gk => gk.korisnik.poeni);
                g.idGrada = grad.id;
                listaGradova.Add(g);
            }

            return listaGradova.OrderByDescending(g => g.brojPoena).Take(10).ToList();
        }

        List<GradKorisnici> IGradKorisniciBL.getAllGradKorisnici()
        {
            return _IGradKorisniciDAL.getAllGradKorisnici();
        }
    }
}
