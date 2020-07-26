using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using backendPoSlojevima.Models;

namespace backendPoSlojevima.BL.Interfaces
{
    public interface IObavestenjaBL
    {
        List<ObavestenjaLajkova> getLajkoveByIdVlasika(long idKorisnika);
        List<ObavestenjaKomentari> getKomentareByIdVlasika(long idKorisnika);
        List<ObavestenjaKomentari> getResenjaByIdVlasika(long idKorisnika);
        void dodajLajk(Lajkovi lajk);
        void dodajKomentar(Komentari komentar);
        void removeLajk(Lajkovi lajk);
        public Korisnik getKorisnikaByLajk(long idLajka);
        public Korisnik getKorisnikByKomentar(long idKomentara);
        public Objave getObjavuByLajk(long lajk);
        public Objave getObjavuByKomentar(long komentar);
        public void procitano(long idKorisnika);
        public long neprocitanaObavestenja(long idKorisnika);
    }
}
