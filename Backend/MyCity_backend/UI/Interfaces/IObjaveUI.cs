using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using backendPoSlojevima.Models;

namespace backendPoSlojevima.UI.Interfaces
{
    public interface IObjaveUI
    {
        List<Objave> getAllObjave();
        void saveObjavu(PrihvatanjeObjave data);
        Korisnik getIdKorisnikaByIdObjave(PrihvatanjeIdObjave data);
        List<SveObjave> vratiSveObjave(PrihvatanjeIdKorisnika aktivanKorisnik);
        List<Objave> getObjaveByIdKorisnika(PrihvatanjeIdKorisnika data);
        List<SveObjave> dajSveObjaveByIdKorisnika(PrihvatanjeIdKorisnika data);
        SveZaObjavu dajSveZaObjavu(PrihvatanjeIdObjave data);
        AktivnostiKorisnika aktivnostiKorisnika(PrihvatanjeIdKorisnika data);
        Objave getObjavaByIdObjave(long idObjave);
        void deleteSveZaObjavuByIdObjave(PrihvatanjeIdObjave objava,int ind);
        void deleteSveZaObjavuByIdKorisnika(PrihvatanjeIdKorisnika korisnik);
        public Objave problemResen(PrihvatanjeIdObjave objave,long ind);
        List<SveObjave> prikaziSveReseneObjave(long idKorisnika);
        List<SveObjave> vratiSveObjaveZaGradove(PrihvatanjeGradova data);
        List<SveObjave> vratiSveObjaveZaGrad(PrihvatanjeIdGrada grad);
        List<SveObjave> dajReseneProblemeZaInstituiju(PrihvatanjeIdInstitucije institucije);
        List<SveObjave> prikaziSveReseneObjaveZaGradove(PrihvatanjeGradova nizGradova);
        List<SveObjave> prikaziSveNereseneObjaveZaGradove(PrihvatanjeGradova nizGradova);
        List<SveObjave> prikazNajpopularnijihObjava(PrihvatanjeGradova nizGradova);
        List<SveObjave> prikazNajnepopularnijihObjava(PrihvatanjeGradova nizGradova);
        List<SveObjave> prikaziObjaveOdDatuma(PrihvatanjeGradova nizGradova);
        List<SveObjave> getNereseneObjaveByGradZa7Dana(long idGrad);
        List<SveObjave> getReseneObjaveByGradZa7Dana(long idGrad);
        List<SveObjave> getReseneObjaveByGrad(long idGrad);
        List<SveObjave> getNereseneObjaveByGrad(long idGrad);
        List<SveObjave> getNereseneObjaveByGradZa30Dana(long idGrad);
        List<SveObjave> getReseneObjaveByGradZa30Dana(long idGrad);
        Statistika prikaziStatistikuSvega();
        List<SveObjave> prikaziObjaveZaAdministratora(long idGrada);
        List<SveObjave> dajNeReseneProblemeZaInstituiju(long idInstitucije);
        public List<SveObjave> prikaziSveReseneObjaveZaInstituciju(long idInstitucije);
        List<SveObjave> getNereseneProblemeByIdKorinsika(long idKorisnika);
        List<SveObjave> getReseneProblemeByIdKorinsika(long idKorisnika);
        List<SveObjave> getReportovaneObjaveByGrada(long idGrada);
        List<SveObjave> getReportovaneObjaveByGradaZa7Dana(long idGrada);
        List<SveObjave> getReportovaneObjaveByGradaZa30Dana(long idGrada);

        List<KorisnikZaAdmina> vratiAdminu(List<KorisnikZaAdmina> lista);
        public List<KategorijeProblema> getKategorijeProblema();
        public List<SveObjave> izlistajSveObjave(IEnumerable<Objave> objave, long aktivanKorisnik);
        public List<LepeStvari> getLepeStavri();

        public List<TopGradovi> topGradoviPoObjavama();
        public List<SveObjave> getObjaveByIdKategorije(long kategorija);
        public List<SveObjave> getObjaveByIdKategorije(List<long> kategorija);
        public List<SveObjave> prikaziPocetnuStranu(long idInstitucije);
        public List<SveObjave> prikaziReseneProblemPocetnuStranu(long idInstitucije);
        public List<SveObjave> prikaziObjavePoKategorijamaZaKorisnika(PrihvatanjeKategorije data);
       
        public List<SveObjave> prikazNeresenihObjavaPoKategorijamaZaKorisnika(PrihvatanjeKategorije data);
        public List<SveObjave> prikazResenihObjavaPoKategorijiZaKorisnika(PrihvatanjeKategorije data);
   
        StatistikaKategorije statistikaPoKategoriji(PrihvatanjeKategorije data);
        List<SveObjave> getReseneObjaveByGradIKategorije(long idGrada, long kategorija);
        List<SveObjave> getNereseneObjaveByGradIKategorije(long idGrada, long kategorija);
        List<SveObjave> getNereseneObjaveByGradIKategorije7Dana(long idGrada, long kategorija);
        List<SveObjave> getReseneObjaveByGradIKategorije7Dana(long idGrada, long kategorija);
        List<SveObjave> getReportovaneObjaveByGradIKategorija(long idGrada, long kategorija);
        List<SveObjave> getReportovaneObjaveByGradIKategorijaZa30Dana(long idGrada, long kategorija);
        List<SveObjave> getReportovaneObjaveByGradIKategorijaZa7Dana(long idGrada, long kategorija);
        public Statistika prikaziStatistiku(long idGrad, long kategorija); //oduvek
        public Statistika prikaziStatistikuZa7Dana(long idGrad, long kategorija); //7 dana
        public Statistika prikaziStatistikuZa30Dana(long idGrad, long kategorija); //30 dana

        public List<StatistikaKategorije> kategorijeSaNajviseObjava();
        public StatistikaObjava tabelaObjava(long idGrada, long idKategorije);
        public StatistikaObjava tabelaObjavaZa7Dana(long idGrada, long idKategorije);
        public StatistikaObjava tabelaObjavaZa30dana(long idGrada, long idKategorije);

        public SveObjave izlistajSveZaObjavu(Objave objava, long idKorisnika);
        public List<SveObjave> dajObjaveZaAdmina(Pretraga data);
        public List<SveObjave> dajProfilInstituciji(PrihvatanjeIdKorisnika data);
        public List<SveObjave> daj10(PrihvatanjeIdKorisnika data);

    }
}
