using backendPoSlojevima.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace backendPoSlojevima.UI.Interfaces
{
    public interface IReportUI
    {
        List<Report> getAllReport();
        public int saveReport(Report data);
        void deleteReportoveByIdObjave(long idObjave);
        void deleteReportoveByIdKorisnika(long idKorisnika);
        List<Report> getReportoveByIdObjave(long idObjave);
        long dajSveReportoveByIdObjave(PrihvatanjeIdObjave data);
        List<Report> getReportoveByKoirsnikId(long data);
        List<Korisnik> getKorisnikeKojiReportujuByIdObjave(PrihvatanjeIdObjave objava);
        long brojReportovaZaVlasnikaObjava(long idKorisnika);
        int getReportByKorisnikId(long idKorisnika, long idObjave);
        List<Objave> getReportovaneObjave();
        MinMaxReportova getMinIMaxBroj();
        List<RazlogPrijave> getRazlogePrijave();
        List<Objave> getReportovaneObjaveByIdGrada(long idGrada);
        List<Objave> getReportovaneObjaveByIdGrada7Dana(long idGrada);
        public List<Objave> getReportovaneObjaveByIdGrada30Dana(long idGrada);
        List<KorisnikIRazlogPrijave> getKorisnikeIRazlogPrijave(long idObjave);
    }
}
