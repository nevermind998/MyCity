using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using backendPoSlojevima.BL.Interfaces;
using backendPoSlojevima.DAL.Interfaces;
using backendPoSlojevima.Models;

namespace backendPoSlojevima.BL
{
    public class ObavestenjaBL : IObavestenjaBL
    {
        private readonly IObavestenjaDAL _IObavestenjaDAL;

        public ObavestenjaBL(IObavestenjaDAL IObavestenjaDAL)
        {
            _IObavestenjaDAL = IObavestenjaDAL;
        }
        public void dodajKomentar(Komentari komentar)
        {
            _IObavestenjaDAL.dodajKomentar(komentar);
        }

        public void dodajLajk(Lajkovi lajk)
        {
            _IObavestenjaDAL.dodajLajk(lajk);
        }
        public List<ObavestenjaKomentari> getKomentareByIdVlasika(long idKorisnika)
        {
            return _IObavestenjaDAL.getKomentareByIdVlasika(idKorisnika);
        }

        public List<ObavestenjaLajkova> getLajkoveByIdVlasika(long idKorisnika)
        {
            return _IObavestenjaDAL.getLajkoveByIdVlasika(idKorisnika);
        }
        public void removeLajk(Lajkovi lajk)
        {
            _IObavestenjaDAL.removeLajk(lajk);
        }


        public List<ObavestenjaKomentari> getResenjaByIdVlasika(long idKorisnika)
        {
            return _IObavestenjaDAL.getResenjaByIdVlasika(idKorisnika);
        }

        public Korisnik getKorisnikaByLajk(long idLajka)
        {
            return _IObavestenjaDAL.getKorisnikaByLajk(idLajka);
        }
        public Korisnik getKorisnikByKomentar(long idKomentara)
        {
            return _IObavestenjaDAL.getKorisnikByKomentar(idKomentara);
        }

        public Objave getObjavuByLajk(long lajk)
        {
            return _IObavestenjaDAL.getObjavuByLajk(lajk);
        }
        public Objave getObjavuByKomentar(long komentar)
        {
            return _IObavestenjaDAL.getObjavuByKomentar(komentar);
        }

        public void procitano(long idKorisnika)
        {
            _IObavestenjaDAL.procitano(idKorisnika);
        }
        public long neprocitanaObavestenja(long idKorisnika)
        {
            return _IObavestenjaDAL.neprocitanaObavestenja(idKorisnika);
        }
    }
}
