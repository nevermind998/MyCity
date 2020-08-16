
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using backendPoSlojevima.UI.Interfaces;
using backendPoSlojevima.BL.Interfaces;
using backendPoSlojevima.Models;

namespace backendPoSlojevima.UI
{
    public class GradKorisniciUI : IGradKorisniciUI
    {
        private readonly IGradKorisniciBL _IGradKorisniciBL;
        private readonly IGradUI _IGradUI;

        public GradKorisniciUI (IGradKorisniciBL IGradKorisniciBL, IGradUI IGradUI)
        {
            _IGradKorisniciBL = IGradKorisniciBL;
            _IGradUI = IGradUI;
        }

        public void deleteGradoveZaKorisnika(long idKorisnika)
        {
            _IGradKorisniciBL.deleteGradoveZaKorisnika(idKorisnika);
        }

        public void dodajKorisnikaZaGradove(PrihvatanjeKorisnika data)
        {
            var idKorisnika = data.korisnik.id;
            List<Grad> nizGradova = _IGradUI.getGradoveByNizIdGradova(data.idGradova);
          
            foreach (var item in nizGradova)
            {
                _IGradKorisniciBL.dodajGradKorisnika(idKorisnika,item.id);
            }
        }

        public List<GradKorisnici> getAllGradKorisnici()
        {
            return _IGradKorisniciBL.getAllGradKorisnici();
        }

        public List<long> getGradoveByIdKorisnika(long idKorisnika)
        {
            return _IGradKorisniciBL.getGradoveByIdKorisnika(idKorisnika);
        }
        public List<Grad> getAllGradoveByIdKorisnika(long idKorisnika)
        {
            var gradKorisnici = _IGradKorisniciBL.getAllGradoveByIdKorisnika(idKorisnika);
            List<Grad> lista = new List<Grad>();
            foreach(var grad in gradKorisnici)
            {
                var ubaci = new Grad();
                ubaci.id = grad.GradID;
                ubaci.naziv_grada_cir = grad.grad.naziv_grada_cir;
                ubaci.naziv_grada_lat = grad.grad.naziv_grada_lat;
                lista.Add(ubaci);
            }

            return lista;

        }
        public List<long> getKorinsikeByIdGrada(long idGrada)
        {
            return _IGradKorisniciBL.getKorinsikeByIdGrada(idGrada);
        }

        public void izmeniGradoveZaKorisnika(long idKorisnika, List<long> nizGradova)
        {
            _IGradKorisniciBL.izmeniGradoveZaKorisnika(idKorisnika, nizGradova);
                
        }

        public List<Korisnik> getListuKorinsikaByIdGrada(long idGrada)
        {
            return _IGradKorisniciBL.getListuKorinsikaByIdGrada(idGrada);
        }

        public List<Korisnik> getGradjaneByIdGrada(long idGrada)
        {
            return _IGradKorisniciBL.getGradjaneByIdGrada(idGrada);
        }

        public List<TopGradovi> top10Gradova()
        {
            return _IGradKorisniciBL.top10Gradova();
        }

        public List<StatistikaGradova> brojKorisnikaPoGradovima()
        {
            var gradovi = _IGradUI.getAllGradove();
            List<StatistikaGradova> lista = new List<StatistikaGradova>();
            foreach(var grad in gradovi)
            {
                StatistikaGradova g = new StatistikaGradova();
                g.idGrada = grad.id;
                g.nazivGrada = grad.naziv_grada_lat;
                g.brojGradjana = _IGradKorisniciBL.getGradjaneByIdGrada(grad.id).Count();
                g.ukupno = _IGradKorisniciBL.getKorinsikeByIdGrada(grad.id).Count();
                g.brojInstitucija = g.ukupno - g.brojGradjana;
                lista.Add(g);

            }

            return lista;
        }
    }
}
