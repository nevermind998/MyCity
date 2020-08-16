using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using backendPoSlojevima.BL.Interfaces;
using backendPoSlojevima.Models;
using backendPoSlojevima.UI.Interfaces;

namespace backendPoSlojevima.UI
{
    public class ObavestenjaUI : IObavestenjaUI
    {
        private readonly IObavestenjaBL _IObavestenjaBL;
        private readonly IKorisnikUI _IKorisnikUI;
        private readonly IGradKorisniciUI _IGradKorisniciUI;
        private readonly IObjaveUI _IObjaveUI;

        public ObavestenjaUI(IObavestenjaBL IObavestenjaBL, IKorisnikUI IKorisnikUI, IGradKorisniciUI IGradKorisniciUI, IObjaveUI IObjaveUI)
        {
            _IObavestenjaBL = IObavestenjaBL;
            _IKorisnikUI = IKorisnikUI;
            _IGradKorisniciUI = IGradKorisniciUI;
            _IObjaveUI = IObjaveUI;
        }
        public void dodajKomentar(Komentari komentar)
        {
            _IObavestenjaBL.dodajKomentar(komentar);
        }

        public void dodajLajk(Lajkovi lajk)
        {
            _IObavestenjaBL.dodajLajk(lajk);
        }
        public List<Obavestenja> getAllObavestenjaByIdVlasnika(long idKorisnika)
        {
            List<Obavestenja> listaObavestenja = new List<Obavestenja>();
            List<ObavestenjaLajkova> listaLajkova = this.getLajkoveByIdVlasika(idKorisnika);
            var listaKomentara = _IObavestenjaBL.getKomentareByIdVlasika(idKorisnika);
            var listaResenih = _IObavestenjaBL.getResenjaByIdVlasika(idKorisnika);
            if (listaLajkova != null)
            {
                foreach (var item in listaLajkova)
                {
                    Obavestenja obavestenje = new Obavestenja();
                    obavestenje.LajkID = item.LajkoviID;
                    obavestenje.procitano = item.procitano;
                    var korisnik = _IObavestenjaBL.getKorisnikaByLajk(item.LajkoviID);
                    obavestenje.korisnik = _IKorisnikUI.convertKorisnika(korisnik);
                    var objava = _IObavestenjaBL.getObjavuByLajk(item.LajkoviID);
                    obavestenje.objava = _IObjaveUI.izlistajSveZaObjavu(objava,idKorisnika);
                    obavestenje.korisnik.gradovi = _IGradKorisniciUI.getAllGradoveByIdKorisnika(korisnik.id);
                    listaObavestenja.Add(obavestenje);
                }
            }
            if (listaKomentara != null)
            {
                foreach (var item in listaKomentara)
                {
                    Obavestenja obavestenje = new Obavestenja();
                    obavestenje.KomentarID = item.KomentarID;
                    obavestenje.procitano = item.procitano;
                    var korisnik = _IObavestenjaBL.getKorisnikByKomentar(item.KomentarID);
                    obavestenje.korisnik = _IKorisnikUI.convertKorisnika(korisnik);
                    var objava = _IObavestenjaBL.getObjavuByKomentar(item.KomentarID);
                    obavestenje.objava = _IObjaveUI.izlistajSveZaObjavu(objava, idKorisnika);
                    obavestenje.korisnik.gradovi = _IGradKorisniciUI.getAllGradoveByIdKorisnika(korisnik.id);
                    listaObavestenja.Add(obavestenje);
                }
            }

            if (listaResenih != null)
            {
                foreach (var item in listaResenih)
                {
                    Obavestenja obavestenje = new Obavestenja();
                    obavestenje.resenje = item.KomentarID;
                    obavestenje.procitano = item.procitano;
                    var korisnik = _IObavestenjaBL.getKorisnikByKomentar(item.KomentarID);
                    obavestenje.korisnik = _IKorisnikUI.convertKorisnika(korisnik);
                    obavestenje.korisnik.gradovi = _IGradKorisniciUI.getAllGradoveByIdKorisnika(korisnik.id);
                    var objava = _IObavestenjaBL.getObjavuByKomentar(item.KomentarID);
                    obavestenje.objava = _IObjaveUI.izlistajSveZaObjavu(objava, idKorisnika);
                    listaObavestenja.Add(obavestenje);
                }

            }


            listaObavestenja.Reverse();
            return listaObavestenja;
        }

        public List<ObavestenjaKomentari> getKomentareByIdVlasika(long idKorisnika)
        {
            return _IObavestenjaBL.getKomentareByIdVlasika(idKorisnika);
        }

        public List<ObavestenjaLajkova> getLajkoveByIdVlasika(long idKorisnika)
        {
            return _IObavestenjaBL.getLajkoveByIdVlasika(idKorisnika);
        }

        public void removeLajk(Lajkovi lajk)
        {
            _IObavestenjaBL.removeLajk(lajk);
        }

        public List<ObavestenjaKomentari> getResenjaByIdVlasika(long idKorisnika)
        {
            return _IObavestenjaBL.getResenjaByIdVlasika(idKorisnika);
        }
        public Korisnik getKorisnikaByLajk(long idLajka)
        {
            return _IObavestenjaBL.getKorisnikaByLajk(idLajka);
        }
        public Korisnik getKorisnikByKomentar(long idKomentara)
        {
            return _IObavestenjaBL.getKorisnikByKomentar(idKomentara);
        }

        public Objave getObjavuByLajk(long lajk)
        {
            return _IObavestenjaBL.getObjavuByLajk(lajk);
        }
        public Objave getObjavuByKomentar(long komentar)
        {
            return _IObavestenjaBL.getObjavuByKomentar(komentar);
        }

        public void procitano(long idKorisnika)
        {
            _IObavestenjaBL.procitano(idKorisnika);
        }

        public long neprocitanaObavestenja(long idKorisnika)
        {
            return _IObavestenjaBL.neprocitanaObavestenja(idKorisnika);
        }

    }
}
