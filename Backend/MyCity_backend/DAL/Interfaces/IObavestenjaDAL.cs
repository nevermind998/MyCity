using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using backendPoSlojevima.Models;

namespace backendPoSlojevima.DAL.Interfaces
{
    public interface IObavestenjaDAL
    {

        List<ObavestenjaLajkova> getLajkoveByIdVlasika(long idKorisnika);
        List<ObavestenjaKomentari> getKomentareByIdVlasika(long idKorisnika);
        List<ObavestenjaKomentari> getResenjaByIdVlasika(long idKorisnika);
        public Korisnik getKorisnikaByLajk(long idLajka);
        public Korisnik getKorisnikByKomentar(long idKomentara);
        void dodajLajk(Lajkovi lajk);
        void dodajKomentar(Komentari komentar);
        void removeLajk(Lajkovi lajk);
        void removeKomentar(Komentari komentar);
        public Objave getObjavuByLajk(long idLajka);
        public Objave getObjavuByKomentar(long idKomentara);
        public void procitano(long idKorisnika);
        public long neprocitanaObavestenja(long idKorisnika);



    }
}
